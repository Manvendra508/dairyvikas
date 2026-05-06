class RecentSearch {
  final String id;
  final String name;

  RecentSearch({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch(id: json['id'], name: json['name']);
  }
}
