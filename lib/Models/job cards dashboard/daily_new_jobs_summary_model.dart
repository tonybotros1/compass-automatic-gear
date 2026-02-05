class NewJobsDailySummary {
  String? sId;
  String? name;
  int? totalNew;
  int? totalNotApproved;
  int? totalApproved;
  int? totalReady;
  int? totalReturned;

  NewJobsDailySummary({
    this.sId,
    this.name,
    this.totalNew,
    this.totalNotApproved,
    this.totalApproved,
    this.totalReady,
    this.totalReturned,
  });

  NewJobsDailySummary.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    totalNew = json.containsKey('total_new') ? json['total_new'] ?? 0 : 0;
    totalNotApproved = json.containsKey('total_not_approved')
        ? json['total_not_approved'] ?? 0
        : 0;
    totalApproved = json.containsKey('total_approved')
        ? json['total_approved'] ?? 0
        : 0;
    totalReady = json.containsKey('total_ready') ? json['total_ready'] ?? 0 : 0;
    totalReturned = json.containsKey('total_returned')
        ? json['total_returned'] ?? 0
        : 0;
  }
}
