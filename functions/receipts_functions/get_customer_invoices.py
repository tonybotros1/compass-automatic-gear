from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from receipts_functions.calculate_net import calculate_all_nets
from receipts_functions.get_receipt_total import get_total_amount_for_job


@https_fn.on_call()
def get_customer_invoices(data: https_fn.CallableRequest) -> dict:
    try:
        customer_id = data.data
        if not customer_id:
            raise ValueError("Missing customerId")

        db = firestore.client()
        jobs_ref = db.collection('job_cards').where(
            filter=FieldFilter('customer', '==', customer_id)
        )
        jobs = jobs_ref.stream()

        result = []
        for job in jobs:
            job_data = job.to_dict()
            job_id = job.id
            invoice_amount = calculate_all_nets(job_id)
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount

            if outstanding > 0:
                result.append({
                    'is_selected': False,
                    'job_id': job_id,
                    'invoice_number': job_data.get('invoice_number', ''),
                    'invoice_date': job_data.get('invoice_date', ''),
                    'invoice_amount': str(invoice_amount),
                    'receipt_amount': str(receipts_amount),
                    'outstanding_amount': str(outstanding),
                    'notes': job_data.get('job_notes', '')
                })

        return {"invoices": result}
    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
