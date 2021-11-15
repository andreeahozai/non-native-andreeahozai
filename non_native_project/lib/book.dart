class Book {
  int id;
  String title;
  String author;
  String category;
  double price;
  int stock;
  String publishing_house;
  Book(
      {this.id = 0,
      required this.title,
      required this.author,
      required this.category,
      required this.price,
      required this.stock,
      required this.publishing_house});
}
