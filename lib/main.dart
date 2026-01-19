class Product {
  final String name;
  final String description;
  final double price;
  final String photo;
  final double weight; // 1. เพิ่มตัวแปร weight

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.photo,
    required this.weight, // 2. เพิ่มใน Constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '', // ใช้ ?? '' กันค่า Null
      description: json['description'] ?? '',
      // แปลงเป็น String ก่อนแล้วค่อย parse เพื่อป้องกัน error กรณี API ส่งมาเป็น int หรือ String
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      photo: json['photo'] ?? '',
      weight: double.tryParse(json['weight'].toString()) ?? 0.0, // 3. ดึงค่าจาก JSON
    );
  }
}