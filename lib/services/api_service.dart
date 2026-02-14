import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _fakeStoreUrl = 'https://fakestoreapi.com/products';
  static const String _dummyJsonUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchFakeStoreProducts() async {
    try {
      final response = await http.get(Uri.parse(_fakeStoreUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJsonFakeStore(json)).toList();
      } else {
        throw Exception('Failed to load products from Fake Store');
      }
    } catch (e) {
      throw Exception('Error fetching Fake Store: $e');
    }
  }

  Future<List<Product>> fetchDummyJsonProducts() async {
    try {
      final response = await http.get(Uri.parse(_dummyJsonUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((json) => Product.fromJsonDummyJSON(json)).toList();
      } else {
        throw Exception('Failed to load products from DummyJSON');
      }
    } catch (e) {
      throw Exception('Error fetching DummyJSON: $e');
    }
  }

  Future<List<Product>> fetchWantApiProducts() async {
    try {
      final response = await http.get(Uri.parse('https://wantapi.com/products.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['data']; // The key is 'data' based on chunk 0
        return productsJson.map((json) => Product.fromJsonWantApi(json)).toList();
      } else {
        throw Exception('Failed to load products from WantAPI');
      }
    } catch (e) {
      throw Exception('Error fetching WantAPI: $e');
    }
  }
}
