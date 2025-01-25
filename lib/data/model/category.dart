class Category {
  final int id;
  final String name;
  final String image;

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['imageUrl'];
}
