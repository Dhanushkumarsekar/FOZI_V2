import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  // ==============================
  // 📸 PICK IMAGE
  // ==============================
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  // ==============================
  // 🚀 ADD PRODUCT (FINAL FIX)
  // ==============================
  Future<void> addProduct() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields + image required ❌")),
      );
      return;
    }

    final parsedPrice = int.tryParse(priceController.text.trim());

    if (parsedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid price ❌")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      print("TOKEN: ${ApiService.token}");

      // ✅ ONLY THIS METHOD EXISTS
      await ApiService.addProductWithImage(
        name: nameController.text.trim(),
        price: parsedPrice,
        imageFile: selectedImage!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Added Successfully ✅")),
      );

      Navigator.pop(context);

    } catch (e) {
      print("UPLOAD ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload Failed ❌")),
      );
    }

    setState(() => isLoading = false);
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// PRODUCT NAME
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGE BOX
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage == null
                    ? const Center(
                        child: Text(
                          "Tap to select image 📸",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            /// UPLOAD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : addProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Upload Product",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}