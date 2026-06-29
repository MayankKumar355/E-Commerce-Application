import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_store/connection/apiConnetion.dart';

import '../../modal/addressModal/addressModal.dart';

class AddressRepository {

  Future<List<AddressModel>> fetchAllAddresses() async {
    final response = await http.get(Uri.parse(ApiConnection.addressAllUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AddressModel.fromJson(json)).toList();
    } else {
      throw Exception("Addresses load nahi ho paye");
    }
  }

  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await http.post(
      Uri.parse(ApiConnection.addressAddUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 201) {
      return AddressModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Address save nahi ho paya");
    }
  }

  Future<bool> toggleAddressSelection(String addressId) async {
    final response = await http.patch(
        Uri.parse('${ApiConnection.addressFetchUrl}/$addressId'));
    return response.statusCode == 200;
  }
}
