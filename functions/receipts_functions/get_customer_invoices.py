from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from receipts_functions.calculate_net import calculate_all_nets
from receipts_functions.get_receipt_total import get_total_amount_for_job
from datetime import datetime


@https_fn.on_call()
def get_customer_invoices(data: https_fn.CallableRequest) -> dict:
    try:
        customer_id = data.data
        if not customer_id:
            raise ValueError("Missing customerId")

        db = firestore.client()
        jobs_ref = db.collection('job_cards').where(
            filter=FieldFilter('customer', '==', customer_id)
        ).where(filter=FieldFilter('job_status_1', '==', 'Posted'))
        jobs = jobs_ref.stream()

        result = []
        for job in jobs:
            job_data = job.to_dict()
            job_id = job.id
            invoice_amount = calculate_all_nets(job_id)
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount

            if outstanding > 0:
                brand_name = ""
                model_name = ""
                brand_id = job_data.get('car_brand')
                model_id = job_data.get('car_model')
                if brand_id:
                    brand_doc = db.collection(
                        'all_brands').document(brand_id).get()
                    if brand_doc.exists:
                        brand_name = brand_doc.to_dict().get('name', '')
                if brand_id and model_id:
                    model_doc = db.collection('all_brands') \
                        .document(brand_id) \
                        .collection('values') \
                        .document(model_id) \
                        .get()
                    if model_doc.exists:
                        model_name = model_doc.to_dict().get('name', '')

                 # Format invoice_date to dd-MM-yyyy
                raw_date = job_data.get('invoice_date', '')
                formatted_date = ''
                if isinstance(raw_date, datetime):
                    formatted_date = raw_date.strftime('%d-%m-%Y')
                else:
                    try:
                        # assume ISO string
                        parsed_date = datetime.fromisoformat(raw_date)
                        formatted_date = parsed_date.strftime('%d-%m-%Y')
                    except Exception:
                        formatted_date = raw_date

                # Build a single-string note with all details
                notes_str = (
                    f"Invoice Number: {job_data.get('invoice_number', '')}, "
                    f"Invoice Date: {formatted_date}, "
                    f"Brand: {brand_name}, "
                    f"Model: {model_name}, "
                    f"Plate Number: {job_data.get('plate_number', '')}"
                )
                result.append({
                    'is_selected': False,
                    'job_id': job_id,
                    'invoice_number': job_data.get('invoice_number', ''),
                    'invoice_date': job_data.get('invoice_date', ''),
                    'invoice_amount': str(invoice_amount),
                    # str(invoice_amount if receipts_amount == 0 else receipts_amount),

                    'receipt_amount':  str(outstanding),
                    'outstanding_amount': str(outstanding),
                    'notes': notes_str
                })

        return {"invoices": result}
    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")


@https_fn.on_call()
def get_current_customer_invoices(data: https_fn.CallableRequest) -> dict:
    from google.cloud.firestore_v1.base_query import FieldFilter
    from datetime import datetime
    try:
        customer_id = data.data.get('customer_id')
        job_ids = data.data.get('job_ids', [])

        if not customer_id:
            raise ValueError("Missing customer_id")
        if not job_ids:
            return

        db = firestore.client()

        result = []
        for job_id in job_ids:
            job_doc = db.collection('job_cards').document(job_id).get()
            if not job_doc.exists:
                continue  # Skip if job_id not found

            job_data = job_doc.to_dict()

            if job_data.get('customer') != customer_id or job_data.get('job_status_1') != 'Posted':
                continue  # Skip if customer doesn't match or status isn't 'Posted'

            invoice_amount = calculate_all_nets(job_id)
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount

            # if outstanding > 0:
            brand_name = ""
            model_name = ""
            brand_id = job_data.get('car_brand')
            model_id = job_data.get('car_model')

            if brand_id:
                brand_doc = db.collection(
                    'all_brands').document(brand_id).get()
                if brand_doc.exists:
                    brand_name = brand_doc.to_dict().get('name', '')

            if brand_id and model_id:
                model_doc = db.collection('all_brands').document(
                    brand_id).collection('values').document(model_id).get()
                if model_doc.exists:
                    model_name = model_doc.to_dict().get('name', '')

            raw_date = job_data.get('invoice_date', '')
            formatted_date = ''
            if isinstance(raw_date, datetime):
                formatted_date = raw_date.strftime('%d-%m-%Y')
            else:
                try:
                    parsed_date = datetime.fromisoformat(raw_date)
                    formatted_date = parsed_date.strftime('%d-%m-%Y')
                except Exception:
                    formatted_date = raw_date

            notes_str = (
                f"Invoice Number: {job_data.get('invoice_number', '')}, "
                f"Invoice Date: {formatted_date}, "
                f"Brand: {brand_name}, "
                f"Model: {model_name}, "
                f"Plate Number: {job_data.get('plate_number', '')}"
            )

            result.append({
                'is_selected': True,
                'job_id': job_id,
                'invoice_number': job_data.get('invoice_number', ''),
                'invoice_date': job_data.get('invoice_date', ''),
                'invoice_amount': str(invoice_amount),
                # str(outstanding),
                'receipt_amount': str(receipts_amount),
                'outstanding_amount': str(outstanding),
                'notes': notes_str
            })

        return {"invoices": result}

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
