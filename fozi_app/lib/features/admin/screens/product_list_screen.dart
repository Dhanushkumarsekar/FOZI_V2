import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  late Future<List<dynamic>> products;

  @override
  void initState() {
    super.initState();
    products = ApiService.getProducts();
  }

  void deleteProduct(String id) async {
    await ApiService.deleteProduct(id);
    setState(() {
      products = ApiService.getProducts();
    });
  }

  void updatePrice(String id) async {
    await ApiService.updateProduct(id, {"price": 999});
    setState(() {
      products = ApiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),

      body: FutureBuilder(
        future: products,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final p = data[i];

              return ListTile(
                title: Text(p['name']),
                subtitle: Text("₹${p['price']}"),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => updatePrice(p['_id']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteProduct(p['_id']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}