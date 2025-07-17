from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


@https_fn.on_call()
def get_payment_paid_amount(data: https_fn.CallableRequest) -> float:
    try:
        payment_id = data.data
        if not payment_id:
            raise ValueError("Missing payment_id")
        db = firestore.client()
        payment_ref = db.collection('all_payments').document(payment_id)
        payments = payment_ref.get()
        payment_data = payments.to_dict()
        ap_invoices = payment_data.get('ap_invoices', {})
        total_paid_amount = sum(float(amount)
                                for amount in ap_invoices.values())

        return {'total_paid_amount': total_paid_amount}

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
