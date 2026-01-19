import 'dart:convert';
import 'product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ฟังก์ชันดึงข้อมูลสินค้า (static เพื่อเรียกใช้ได้เลยไม่ต้อง new class)
  static Future<List<Product>> fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse("https://6964b1fbe8ce952ce1f28b92.mockapi.io/products"),
      );

      // เช็คว่า Server ตอบกลับมาว่า OK (200) หรือไม่
      if (response.statusCode == 200) {
        // แปลง JSON String -> List
        final List data = jsonDecode(response.body);
        // วนลูปแปลง List JSON -> List<Product>
        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      // จับ Error อื่นๆ เช่น เน็ตหลุด
      throw Exception('Failed to load products: $e');
    }
  }
}