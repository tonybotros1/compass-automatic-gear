from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from receipts_functions.calculate_net import calculate_all_nets
from receipts_functions.get_receipt_total import get_total_amount_for_job


@https_fn.on_call()
def calculate_vendor_outstanding(data: https_fn.CallableRequest) -> dict:
    try:
        vendor_id = data.data
        if not vendor_id:
            raise ValueError("Missing vendorId")

        db = firestore.client()
        ap_invoices_ref = db.collection('ap_invoices').where(
            filter=FieldFilter('vendor', '==', vendor_id)
        ).where(filter=FieldFilter('status', '==', 'Posted'))
        ap_invoices = ap_invoices_ref.stream()
        total_outstanding = 0.0
        for job in ap_invoices:
            job_id = job.id
            invoice_amount = calculate_all_nets(job_id)
            receipts_amount = get_total_amount_for_job(job_id)
            outstanding = invoice_amount - receipts_amount
            total_outstanding += outstanding

        return total_outstanding

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
