import 'package:shopping_store/data/modal/addressModal/addressModal.dart';
import 'package:shopping_store/utils/helpers/helper_functions.dart';
import 'package:shopping_store/data/modal/cartModal/cartModal.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartModal> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    required this.paymentMethod,
    this.address,
    this.deliveryDate,
    required this.items,
  });

  String get formattedOrderDate => HkHelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => HkHelperFunctions.getFormattedDate(deliveryDate!);

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.pending ? 'Pending'
      : status == OrderStatus.processing ? 'Processing'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      status: OrderStatus.values.firstWhere(
            (e) => e.name == (json['status'] ?? 'pending').toString().toLowerCase(),
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : DateTime.now(),
      paymentMethod: json['paymentMethod'] ?? '',
      address: json['address'] != null ? AddressModel.fromJson(json['address']) : null,
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
      items: json['items'] != null
          ? (json['items'] as List).map((i) => CartModal.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.name,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
