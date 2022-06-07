class Category {
  String? id;
  String categoryName;
  int categorySort;
  String? syncDt;

  Category(
      {this.id,
      required this.categoryName,
      this.categorySort = 0,
      this.syncDt});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        categoryName: json['categoryName'],
        categorySort: json['categorySort'],
        syncDt: json['syncDt']);
  }
}
