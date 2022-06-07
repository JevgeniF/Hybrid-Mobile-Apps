class Priority {
  String? appUserId;
  String priorityName;
  int prioritySort;
  String? syncDt;
  String? id;

  Priority(
      {this.appUserId,
      required this.priorityName,
      this.prioritySort = 0,
      this.syncDt,
      this.id});

  factory Priority.fromJson(Map<String, dynamic> json) {
    return Priority(
        appUserId: json['appUserId'],
        priorityName: json['priorityName'],
        prioritySort: json['prioritySort'],
        syncDt: json['syncDt'],
        id: json['id']);
  }
}
