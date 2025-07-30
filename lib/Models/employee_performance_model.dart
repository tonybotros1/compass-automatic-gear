class EmployeePerformanceModel {

  String? employeeName;
  int? mins;
  int? points;
  int? tasks;

  EmployeePerformanceModel({
   this.employeeName,this.mins,this.points,this.tasks
  });

  int get amt => (mins ?? 0) + (points ?? 0) + (tasks ?? 0);

}