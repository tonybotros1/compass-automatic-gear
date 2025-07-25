from firebase_admin import initialize_app, firestore
from google.cloud.firestore_v1.base_query import FieldFilter


# # Initialize the Firebase Admin SDK
app = initialize_app()

from receipts_functions.get_customer_invoices import get_customer_invoices
from receipts_functions.get_customer_invoices import get_current_customer_invoices
from receipts_functions.get_customer_outstanding import calculate_customer_outstanding
# from receipts_functions.get_customer_outstanding import calculate_customer_outstanding2
from receipts_functions.get_receipt_received_amount import get_receipt_received_amount
from payments_functions.get_payment_paid_amount import get_payment_paid_amount
from currency_functions.get_currency_data import get_currency_name
from currency_functions.get_currency_data import get_currency_rate
from brand_and_models.get_model_data import get_model_name
from brand_and_models.get_model_data import get_brand_name
from car_trading.get_trade_totals import get_trade_total_paid
from car_trading.get_trade_totals import get_trade_total_received
from car_trading.get_trade_totals import get_trade_total_NETs
from car_trading.get_trade_dates import get_sell_date
from car_trading.get_trade_dates import get_buy_date
from car_trading.get_trade_dates import get_item_name

# @https_fn.on_call()
# def get_customer_invoices(data: https_fn.CallableRequest) -> dict:
#     try:
#         customer_id = data.data
#         if not customer_id:
#             raise ValueError("Missing customerId")

#         db = firestore.client()
#         jobs_ref = db.collection('job_cards').where(filter=FieldFilter(
#             'customer', '==', customer_id))
#         jobs = jobs_ref.stream()

#         result = []
#         for job in jobs:
#             job_data = job.to_dict()
#             job_id = job.id
#             invoice_amount = calculate_all_nets(job_id)
#             receipts_amount = get_total_amount_for_job(job_id)
#             outstanding = invoice_amount - receipts_amount

#             if outstanding > 0:
#                 result.append({
#                     'is_selected': False,
#                     'job_id': job_id,
#                     'invoice_number': job_data.get('invoice_number', ''),
#                     'invoice_date': job_data.get('invoice_date', ''),
#                     'invoice_amount': str(invoice_amount),
#                     'receipt_amount': str(receipts_amount),
#                     'outstanding_amount': str(outstanding),
#                     'notes': job_data.get('job_notes', '')
#                 })

#         return {"invoices": result}
#     except Exception as e:
#         raise https_fn.HttpsError("internal", f"Error: {str(e)}")


# def get_total_amount_for_job(job_id: str) -> float:
#     db = firestore.client()
#     total = 0.0
#     receipts_ref = db.collection('all_receipts').where(filter=FieldFilter(
#         'job_ids', 'array_contains', job_id))
#     receipts = receipts_ref.stream()
#     for receipt in receipts:
#         receipt_data = receipt.to_dict()
#         jobs = receipt_data.get('jobs', {})
#         total += float(jobs.get(job_id, 0))
#     return total


# def calculate_all_nets(job_id: str) -> float:
#     db = firestore.client()
#     sum_net = 0.0
#     items_ref = db.collection('job_cards').document(
#         job_id).collection('invoice_items')
#     items = items_ref.stream()
#     for item in items:
#         item_data = item.to_dict()
#         net_value = item_data.get('net', 0)
#         try:
#             sum_net += float(net_value)
#         except (TypeError, ValueError):
#             continue
#     return sum_net
