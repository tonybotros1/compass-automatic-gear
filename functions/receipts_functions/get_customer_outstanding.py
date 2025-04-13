from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from receipts_functions.calculate_net import calculate_all_nets
from receipts_functions.get_receipt_total import get_total_amount_for_job


@https_fn.on_call()
def calculate_customer_outstanding(data: https_fn.CallableRequest) -> dict:
    try:
        customer_id = data.data
        if not customer_id:
            raise ValueError("Missing customerId")

        db = firestore.client()
        jobs_ref = db.collection('job_cards').where(
            filter=FieldFilter('customer', '==', customer_id)
        ).where(filter=FieldFilter('job_status_1', '==', 'Posted'))
        jobs = jobs_ref.stream()
        total_outstanding = 0.0
        for job in jobs:
            job_id = job.id
            invoice_amount = calculate_all_nets(job_id)
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount
            total_outstanding += outstanding

        return total_outstanding

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
