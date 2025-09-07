from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from receipts_functions.calculate_net import calculate_all_nets
from receipts_functions.get_receipt_total import get_total_amount_for_job
from datetime import datetime


# @https_fn.on_call()
# def get_customer_invoices(data: https_fn.CallableRequest) -> dict:
#     try:
#         customer_id = data.data
#         if not customer_id:
#             raise ValueError("Missing customerId")

#         db = firestore.client()
#         jobs_ref = db.collection('job_cards').where(
#             filter=FieldFilter('customer', '==', customer_id)
#         ).where(filter=FieldFilter('job_status_1', '==', 'Posted'))
#         jobs = jobs_ref.stream()

#         result = []
#         for job in jobs:
#             job_data = job.to_dict()
#             job_id = job.id
#             invoice_amount = job_data.get('total_net_amount', 0)
#             receipts_amount = get_total_amount_for_job(job_id)
#             outstanding = invoice_amount - receipts_amount

#             if outstanding > 0:
#                 brand_name = ""
#                 model_name = ""
#                 brand_id = job_data.get('car_brand')
#                 model_id = job_data.get('car_model')
#                 if brand_id:
#                     brand_doc = db.collection(
#                         'all_brands').document(brand_id).get()
#                     if brand_doc.exists:
#                         brand_name = brand_doc.to_dict().get('name', '')
#                 if brand_id and model_id:
#                     model_doc = db.collection('all_brands') \
#                         .document(brand_id) \
#                         .collection('values') \
#                         .document(model_id) \
#                         .get()
#                     if model_doc.exists:
#                         model_name = model_doc.to_dict().get('name', '')

#                  # Format invoice_date to dd-MM-yyyy
#                 raw_date = job_data.get('invoice_date', '')
#                 formatted_date = ''
#                 if isinstance(raw_date, datetime):
#                     formatted_date = raw_date.strftime('%d-%m-%Y')
#                 else:
#                     try:
#                         # assume ISO string
#                         parsed_date = datetime.fromisoformat(raw_date)
#                         formatted_date = parsed_date.strftime('%d-%m-%Y')
#                     except Exception:
#                         formatted_date = raw_date

#                 # Build a single-string note with all details
#                 notes_str = (
#                     f"Invoice Number: {job_data.get('invoice_number', '')}, "
#                     f"Invoice Date: {formatted_date}, "
#                     f"Brand: {brand_name}, "
#                     f"Model: {model_name}, "
#                     f"Plate Number: {job_data.get('plate_number', '')}"
#                 )
#                 result.append({
#                     'is_selected': False,
#                     'job_id': job_id,
#                     'invoice_number': job_data.get('invoice_number', ''),
#                     'invoice_date': job_data.get('invoice_date', ''),
#                     'invoice_amount': str(invoice_amount),
#                     # str(invoice_amount if receipts_amount == 0 else receipts_amount),

#                     'receipt_amount':  str(outstanding),
#                     'outstanding_amount': str(outstanding),
#                     'notes': notes_str
#                 })

#         return {"invoices": result}
#     except Exception as e:
#         raise https_fn.HttpsError("internal", f"Error: {str(e)}")

_db = None


def get_db():
    """Returns a cached Firestore client instance."""
    global _db
    if _db is None:
        _db = firestore.client()
    return _db


@https_fn.on_call()
def get_customer_invoices(data: https_fn.CallableRequest) -> dict:
    try:
        customer_id = data.data
        if not customer_id:
            raise https_fn.HttpsError(
                "invalid-argument", "Missing customerId in request data."
            )

        db = get_db()

        # Fetch all job cards for the customer with 'Posted' status
        jobs_query = db.collection('job_cards').where(
            filter=firestore.FieldFilter('customer', '==', customer_id)
        ).where(filter=firestore.FieldFilter('job_status_1', '==', 'Posted'))
        jobs_docs = list(jobs_query.stream())  # Fetch all documents in one go

        # Pre-fetch all necessary brand and model data to avoid N+1 queries
        # This will be done by collecting all unique brand and model IDs first.
        unique_brand_ids = set()
        brand_model_pairs = set()

        for job_doc in jobs_docs:
            job_data = job_doc.to_dict()
            brand_id = job_data.get('car_brand')
            model_id = job_data.get('car_model')
            if brand_id:
                unique_brand_ids.add(brand_id)
                if model_id:
                    brand_model_pairs.add((brand_id, model_id))

        # Fetch brands
        brands_map = {}
        if unique_brand_ids:
            # Firestore doesn't directly support 'in' queries on document IDs across collections
            # For a small number of brands, individual gets are fine.
            # If unique_brand_ids can be large, consider fetching them in batches or restructuring.
            # However, for 'all_brands' collection, it's likely a small, manageable number.
            for brand_id in unique_brand_ids:
                brand_doc_ref = db.collection('all_brands').document(brand_id)
                brand_doc = brand_doc_ref.get()
                if brand_doc.exists:
                    brands_map[brand_id] = brand_doc.to_dict().get('name', '')

        # Fetch models (nested collection)
        models_map = {}
        for brand_id, model_id in brand_model_pairs:
            model_doc_ref = db.collection('all_brands').document(
                brand_id).collection('values').document(model_id)
            model_doc = model_doc_ref.get()
            if model_doc.exists:
                models_map[(brand_id, model_id)
                           ] = model_doc.to_dict().get('name', '')

        result = []
        for job_doc in jobs_docs:
            job_data = job_doc.to_dict()
            job_id = job_doc.id
            invoice_amount = job_data.get('total_net_amount', 0)

            # This call still remains for each job, so optimizing get_total_amount_for_job
            # is crucial if it's a bottleneck.
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount

            if outstanding > 0:
                brand_id = job_data.get('car_brand')
                model_id = job_data.get('car_model')

                brand_name = brands_map.get(brand_id, '')
                model_name = models_map.get((brand_id, model_id), '')

                # Format invoice_date to dd-MM-yyyy
                raw_date = job_data.get('invoice_date', '')
                formatted_date = ''
                if isinstance(raw_date, datetime):
                    formatted_date = raw_date.strftime('%d-%m-%Y')
                elif isinstance(raw_date, str):
                    try:
                        parsed_date = datetime.fromisoformat(raw_date)
                        formatted_date = parsed_date.strftime('%d-%m-%Y')
                    except ValueError:  # Catch more specific error for fromisoformat
                        formatted_date = raw_date  # Keep raw string if parsing fails
                # If raw_date is neither datetime nor a valid string, formatted_date remains ''

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
                    'invoice_date': formatted_date,  # Use formatted_date here
                    'invoice_amount': str(invoice_amount),
                    # Use the actual receipts_amount here
                    'receipt_amount': str(receipts_amount),
                    'outstanding_amount': str(outstanding),
                    'notes': notes_str
                })

        return {"invoices": result}
    except https_fn.HttpsError as e:
        # Re-raise HttpsError directly
        raise e
    except Exception as e:
        # Catch any other unexpected errors and return a generic internal error
        raise https_fn.HttpsError(
            "internal", f"An unexpected error occurred: {str(e)}")


# @https_fn.on_call()
# def get_current_customer_invoices(data: https_fn.CallableRequest) -> dict:
#     from google.cloud.firestore_v1.base_query import FieldFilter
#     from datetime import datetime
#     try:
#         customer_id = data.data.get('customer_id')
#         job_ids = data.data.get('job_ids', [])

#         if not customer_id:
#             raise ValueError("Missing customer_id")
#         if not job_ids:
#             return

#         db = firestore.client()

#         result = []
#         for job_id in job_ids:
#             job_doc = db.collection('job_cards').document(job_id).get()
#             if not job_doc.exists:
#                 continue  # Skip if job_id not found

#             job_data = job_doc.to_dict()

#             if job_data.get('customer') != customer_id or job_data.get('job_status_1') != 'Posted':
#                 continue  # Skip if customer doesn't match or status isn't 'Posted'

#             invoice_amount = job_data.get('total_net_amount', 0)
#             receipts_amount = get_total_amount_for_job(job_id)
#             outstanding = invoice_amount - receipts_amount

#             # if outstanding > 0:
#             brand_name = ""
#             model_name = ""
#             brand_id = job_data.get('car_brand')
#             model_id = job_data.get('car_model')

#             if brand_id:
#                 brand_doc = db.collection(
#                     'all_brands').document(brand_id).get()
#                 if brand_doc.exists:
#                     brand_name = brand_doc.to_dict().get('name', '')

#             if brand_id and model_id:
#                 model_doc = db.collection('all_brands').document(
#                     brand_id).collection('values').document(model_id).get()
#                 if model_doc.exists:
#                     model_name = model_doc.to_dict().get('name', '')

#             raw_date = job_data.get('invoice_date', '')
#             formatted_date = ''
#             if isinstance(raw_date, datetime):
#                 formatted_date = raw_date.strftime('%d-%m-%Y')
#             else:
#                 try:
#                     parsed_date = datetime.fromisoformat(raw_date)
#                     formatted_date = parsed_date.strftime('%d-%m-%Y')
#                 except Exception:
#                     formatted_date = raw_date

#             notes_str = (
#                 f"Invoice Number: {job_data.get('invoice_number', '')}, "
#                 f"Invoice Date: {formatted_date}, "
#                 f"Brand: {brand_name}, "
#                 f"Model: {model_name}, "
#                 f"Plate Number: {job_data.get('plate_number', '')}"
#             )

#             result.append({
#                 'is_selected': True,
#                 'job_id': job_id,
#                 'invoice_number': job_data.get('invoice_number', ''),
#                 'invoice_date': job_data.get('invoice_date', ''),
#                 'invoice_amount': str(invoice_amount),
#                 # str(outstanding),
#                 'receipt_amount': str(receipts_amount),
#                 'outstanding_amount': str(outstanding),
#                 'notes': notes_str
#             })

#         return {"invoices": result}

#     except Exception as e:
#         raise https_fn.HttpsError("internal", f"Error: {str(e)}")


@https_fn.on_call()
def get_current_customer_invoices(data: https_fn.CallableRequest) -> dict:
    try:
        customer_id = data.data.get('customer_id')
        job_ids = data.data.get('job_ids', [])

        if not customer_id:
            raise https_fn.HttpsError(
                "invalid-argument", "Missing customer_id in request data."
            )
        if not job_ids:
            return {"invoices": []}

        db = get_db()

        job_docs_map = {}
        job_refs = [db.collection('job_cards').document(job_id) 
                    for job_id in job_ids]

        fetched_job_docs = db.get_all(job_refs)
        for doc in fetched_job_docs:
            if doc.exists:
                job_docs_map[doc.id] = doc

        unique_brand_ids = set()
        brand_model_pairs = set()

        for job_id in job_ids:
            job_doc = job_docs_map.get(job_id)
            if job_doc and job_doc.exists:  # Ensure doc exists before processing
                job_data = job_doc.to_dict()
                if job_data.get('customer') == customer_id and job_data.get('job_status_1') == 'Posted':
                    brand_id = job_data.get('car_brand')
                    model_id = job_data.get('car_model')
                    if brand_id:
                        unique_brand_ids.add(brand_id)
                        if model_id:
                            brand_model_pairs.add((brand_id, model_id))

        brands_map = {}
        if unique_brand_ids:
            for brand_id in unique_brand_ids:
                brand_doc_ref = db.collection('all_brands').document(brand_id)
                brand_doc = brand_doc_ref.get()
                if brand_doc.exists:
                    brands_map[brand_id] = brand_doc.to_dict().get('name', '')

        models_map = {}
        for brand_id, model_id in brand_model_pairs:
            model_doc_ref = db.collection('all_brands').document(
                brand_id).collection('values').document(model_id)
            model_doc = model_doc_ref.get()
            if model_doc.exists:
                models_map[(brand_id, model_id)
                           ] = model_doc.to_dict().get('name', '')

        result = []
        for job_id in job_ids:
            job_doc = job_docs_map.get(job_id)
            if not job_doc or not job_doc.exists:
                continue

            job_data = job_doc.to_dict()

            if job_data.get('customer') != customer_id or job_data.get('job_status_1') != 'Posted':
                continue

            invoice_amount = job_data.get('total_net_amount', 0)

            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount

            brand_id = job_data.get('car_brand')
            model_id = job_data.get('car_model')

            brand_name = brands_map.get(brand_id, '')
            model_name = models_map.get((brand_id, model_id), '')

            raw_date = job_data.get('invoice_date', '')
            formatted_date = ''
            if isinstance(raw_date, datetime):
                formatted_date = raw_date.strftime('%d-%m-%Y')
            elif isinstance(raw_date, str):
                try:
                    parsed_date = datetime.fromisoformat(raw_date)
                    formatted_date = parsed_date.strftime('%d-%m-%Y')
                except ValueError:
                    formatted_date = raw_date

            notes_str = (
                f"Invoice Number: {job_data.get('invoice_number', '')}, "
                f"Invoice Date: {formatted_date}, "
                f"Brand: {brand_name}, "
                f"Model: {model_name}, "
                f"Plate Number: {job_data.get('plate_number', '')}"
            )

            result.append({
                'is_selected': True,  # Keep as True based on original code
                'job_id': job_id,
                'invoice_number': job_data.get('invoice_number', ''),
                'invoice_date': formatted_date,  # Use formatted_date here
                'invoice_amount': str(invoice_amount),
                'receipt_amount': str(receipts_amount),
                'outstanding_amount': str(outstanding),
                'notes': notes_str
            })

        return {"invoices": result}

    except https_fn.HttpsError as e:
        raise e
    except Exception as e:
        raise https_fn.HttpsError(
            "internal", f"An unexpected error occurred: {str(e)}")
