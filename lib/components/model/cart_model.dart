class CartItem {
  final Map<String, dynamic> service;
  int quantity;
  bool includeIroning;

  CartItem({
    required this.service,
    this.quantity = 1,
    this.includeIroning = false,
  });

  double get totalPrice => service['price'] * quantity;
}