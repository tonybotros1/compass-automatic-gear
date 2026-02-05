class JobsDailySummary {
  String? sId;
  String? name;
  int? totalPosted;
  int? totalNew;
  int? jobCounts;
  double? totalItemsAmount;
  double? totalItemsNet;
  double? totalItemsPaid;

  JobsDailySummary({
    this.sId,
    this.name,
    this.totalPosted,
    this.totalNew,
    this.totalItemsAmount,
    this.totalItemsNet,
    this.totalItemsPaid,
    this.jobCounts,
  });

  JobsDailySummary.fromJson(Map<String, dynamic> json) {
    sId = json.containsKey('_id') ? json['_id'] ?? '' : '';
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    totalPosted = json.containsKey('total_posted')
        ? json['total_posted'] ?? ''
        : '';
    totalNew = json.containsKey('total_new') ? json['total_new'] ?? '' : '';
    totalItemsAmount = json.containsKey('total_items_amount')
        ? json['total_items_amount'] ?? ''
        : '';
    totalItemsNet = json.containsKey('total_items_net')
        ? json['total_items_net'] ?? ''
        : '';
    totalItemsPaid = json.containsKey('total_items_paid')
        ? json['total_items_paid'] ?? ''
        : '';
    jobCounts = json.containsKey('jobs_count') ? json['jobs_count'] ?? 0 : 0;
  }
}
