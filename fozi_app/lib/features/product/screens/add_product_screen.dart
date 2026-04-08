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
  final nameController = TextEditingController();
  final priceController = TextEditingController();

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
  // 🚀 UPLOAD PRODUCT
  // ==============================
  Future<void> uploadProduct() async {
    print("TOKEN: ${ApiService.token}");

    // 🔥 VALIDATION
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
      await ApiService.addProductWithImage(
        name: nameController.text.trim(),
        price: parsedPrice,
        imageFile: selectedImage!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Added ✅")),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGE PREVIEW
            selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      selectedImage!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Text("No image selected"),

            const SizedBox(height: 10),

            /// SELECT IMAGE BUTTON
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Select Image 📸"),
            ),

            const SizedBox(height: 25),

            /// UPLOAD BUTTON
            ElevatedButton(
              onPressed: isLoading ? null : uploadProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload Product"),
            ),
          ],
        ),
      ),
    );
  }
}