from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
# from google.cloud.firestore_v1 import FieldPath


@https_fn.on_call()
def get_currency_name(data: https_fn.CallableRequest) -> dict:
    try:
        country_id = data.data
        if not country_id:
            raise ValueError('Missing Country ID')

        db = firestore.client()
        country_ref = db.collection('all_countries').document(country_id)
        country = country_ref.get()
        country_data = country.to_dict()
        currency = country_data.get('currency_code', '')

        return currency

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")


@https_fn.on_call()
def get_currency_rate(data: https_fn.CallableRequest) -> dict:
    try:
        currency_id = data.data
        if not currency_id:
            raise ValueError('Missing Currency ID')

        db = firestore.client()
        # Get the document reference directly
        doc_ref = db.collection('currencies').document(currency_id)
        # Get the document snapshot
        currency_doc = doc_ref.get()

        if not currency_doc.exists:
            raise https_fn.HttpsError(
                "not-found", "Currency not found or inactive")

        return currency_doc.to_dict()['rate']

    except Exception as e:
        raise https_fn.HttpsError("internal", f"Error: {str(e)}")
