class Task {
  String? id;
  String taskName;
  int taskSort;
  String? createdDt;
  String? dueDt;
  bool isCompleted;
  bool isArchived;
  String todoCategoryId;
  String todoPriorityId;
  String? syncDt;

  Task(
      {this.id,
      required this.taskName,
      this.taskSort = 0,
      this.createdDt,
      this.dueDt,
      this.isCompleted = false,
      this.isArchived = false,
      required this.todoCategoryId,
      required this.todoPriorityId,
      this.syncDt});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        taskName: json['taskName'],
        taskSort: json['taskSort'],
        createdDt: json['createDt'],
        dueDt: json['dueDt'],
        isCompleted: json['isCompleted'],
        isArchived: json['isArchived'],
        todoCategoryId: json['todoCategoryId'],
        todoPriorityId: json['todoPriorityId'],
        syncDt: json['syncDt']);
  }
}
