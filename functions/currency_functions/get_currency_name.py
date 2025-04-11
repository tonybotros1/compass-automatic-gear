from firebase_functions import https_fn
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


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
