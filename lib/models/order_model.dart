class OrderItem {
  final String productId;
  final String name;
  final String? image;
  final double price;
  final int quantity;

  OrderItem({required this.productId, required this.name, this.image, required this.price, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['product'] is Map ? json['product']['_id'] : (json['product'] ?? ''),
        name: json['name'] ?? '',
        image: json['image'],
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 1,
      );
}

/// Mirrors the backend Order status enum - drives the order tracking UI stepper.
enum OrderStatus { placed, confirmed, preparing, baking, outForDelivery, delivered, cancelled }

OrderStatus orderStatusFromString(String s) {
  switch (s) {
    case 'confirmed':
      return OrderStatus.confirmed;
    case 'preparing':
      return OrderStatus.preparing;
    case 'baking':
      return OrderStatus.baking;
    case 'out_for_delivery':
      return OrderStatus.outForDelivery;
    case 'delivered':
      return OrderStatus.delivered;
    case 'cancelled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.placed;
  }
}

class BakeryOrder {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double gst;
  final double discount;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final OrderStatus status;
  final DateTime createdAt;

  BakeryOrder({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.gst,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
  });

  factory BakeryOrder.fromJson(Map<String, dynamic> json) => BakeryOrder(
        id: json['_id'] ?? '',
        orderNumber: json['orderNumber'] ?? '',
        items: (json['items'] as List? ?? []).map((i) => OrderItem.fromJson(i)).toList(),
        subtotal: (json['pricing']?['subtotal'] ?? 0).toDouble(),
        deliveryCharge: (json['pricing']?['deliveryCharge'] ?? 0).toDouble(),
        gst: (json['pricing']?['gst'] ?? 0).toDouble(),
        discount: (json['pricing']?['discount'] ?? 0).toDouble(),
        total: (json['pricing']?['total'] ?? 0).toDouble(),
        paymentMethod: json['paymentMethod'] ?? 'cod',
        paymentStatus: json['paymentStatus'] ?? 'pending',
        status: orderStatusFromString(json['status'] ?? 'placed'),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}
