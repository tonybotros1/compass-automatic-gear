class EmployeePerformanceModel {
  String? employeeName;
  String? mins;
  int? points;
  int? tasks;
  double? allPoints;
  double? jobsTotal;

  EmployeePerformanceModel({
    this.employeeName,
    this.mins,
    this.points,
    this.tasks,
    this.allPoints,
    this.jobsTotal,
  });

  double get amt {
    if (points == null ||
        jobsTotal == null ||
        allPoints == null ||
        allPoints == 0) {
      return 0;
    }
    return (points! * jobsTotal! * 0.1) / allPoints!;
  }
}
