class LineItemModel {
  String title;
  double price;
  int quantity;
  double totalPrice;

  LineItemModel({
    required this.title,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'quantity': quantity,
        'totalPrice': totalPrice,
      };

  factory LineItemModel.fromJson(Map<String, dynamic> json) {
    return LineItemModel(
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
    );
  }
}
