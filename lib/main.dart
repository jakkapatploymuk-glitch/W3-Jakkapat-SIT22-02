import 'package:flutter/material.dart';
// ตรวจสอบชื่อ package ให้ตรงกับโปรเจกต์ของคุณ
import 'api_service.dart';
import 'product_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ปิดป้าย Debug มุมขวาบน
      title: 'Product Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Product List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // สร้างตัวแปร Future เพื่อเก็บสถานะการโหลด
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    // เรียกโหลดข้อมูลครั้งเดียวตอนเริ่มหน้าจอ
    _futureProducts = ApiService.fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // FutureBuilder ใช้สำหรับรอข้อมูลแบบ Asynchronous (เช่น ข้อมูลจากเน็ต)
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {

          // 1. กรณีกลังโหลดข้อมูล
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. กรณีเกิดข้อผิดพลาด (Error)
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  Text("เกิดข้อผิดพลาด: ${snapshot.error}"),
                ],
              ),
            );
          }

          // 3. กรณีโหลดเสร็จแล้วแต่ไม่มีข้อมูล
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("ไม่พบสินค้า"));
          }

          // 4. กรณีมีข้อมูลพร้อมแสดงผล
          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8), // เว้นระยะขอบรอบๆ List
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];

              // ใช้ Card เพื่อความสวยงาม มีเงาและขอบมน
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ส่วนแสดงรูปภาพ
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8), // ตัดขอบรูปให้มน
                        child: Image.network(
                          p.photo,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover, // ให้รูปเต็มกรอบพอดี
                          // กรณีรูปโหลดไม่ได้ ให้แสดง icon แทน
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 15), // เว้นระยะห่างระหว่างรูปกับข้อความ

                      // ส่วนข้อความ (ใช้ Expanded เพื่อให้ข้อความไม่ดันออกนอกจอ)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // ถ้าชื่อยา....วไป3333ให้เป.....็333น ...
                            ),
                            const SizedBox(height: 5),
                            Text(
                              p.description,
                              style: TextStyle(color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "ราคา: ฿${p.price.toStringAsFixed(2)}", // ทศนิยม 2 ตำแหน่ง
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}