class Product {
  final String id;
  final String name;
  final String photo;
  final double price;
  final int weight;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.photo,
    required this.price,
    required this.weight,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '', // แปลง id เป็น String เสมอเพื่อความชัวร์
      name: json['name'] ?? 'No Name',
      photo: json['photo'] ?? '',

      // --- จุดที่แก้ไข ---
      // 1. แปลงค่าเป็น String ด้วย .toString() ก่อน (เผื่อ API ส่งมาเป็นตัวเลขหรือข้อความ)
      // 2. ใช้ tryParse เพื่อแปลงเป็น double/int ถ้าแปลงไม่ได้ให้เป็น 0
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      weight: int.tryParse(json['weight'].toString()) ?? 0,
      // -----------------

      description: json['description'] ?? '',
    );
  }
}