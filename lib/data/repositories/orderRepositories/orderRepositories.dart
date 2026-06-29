import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_store/connection/apiConnetion.dart';

import '../../modal/orderModal/orderModal.dart';

class OrderRepository {

  Future<OrderModel?> createOrder(OrderModel order) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnection.ordersFetchUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return OrderModel.fromJson(responseData);
      } else {
        print('Failed to create order. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in createOrder Repository: $e');
      return null;
    }
  }

  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConnection.ordersFetchUrl}$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((order) => OrderModel.fromJson(order)).toList();
      } else {
        print('Failed to fetch orders. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in fetchUserOrders Repository: $e');
      return [];
    }
  }

}
