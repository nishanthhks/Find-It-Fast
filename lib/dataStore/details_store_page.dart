import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DetailsStorePage extends StatefulWidget {
  const DetailsStorePage({Key? key}) : super(key: key);

  @override
  State<DetailsStorePage> createState() => _DetailsStorePageState();
}

class _DetailsStorePageState extends State<DetailsStorePage> {
  final CollectionReference itemDetails =
      FirebaseFirestore.instance.collection('lost_items');
  final ImagePicker _picker = ImagePicker();

  final TextEditingController floorController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController founderNameController = TextEditingController();
  final TextEditingController founderUsnController = TextEditingController();
  final TextEditingController founderEmailController = TextEditingController();

  List<XFile> selectedImages = [];
  bool isLoading = false;

  Future<void> pickImages(ImageSource source) async {
    try {
      final List<XFile>? pickedFiles = source == ImageSource.gallery
          ? await _picker.pickMultiImage()
          : [(await _picker.pickImage(source: source))!];

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        if (selectedImages.length + pickedFiles.length <= 4) {
          setState(() {
            selectedImages.addAll(pickedFiles);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only select up to 4 images.')),
          );
        }
      }
    } catch (e) {
      print("Error picking images: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<List<String>> uploadImages() async {
    List<String> downloadUrls = [];
    for (XFile image in selectedImages) {
      try {
        File file = File(image.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(founderUsnController.text)
            .child(fileName)
            .putFile(file);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
        print('Image uploaded: $downloadUrl'); // Debug print
      } catch (e) {
        print("Error uploading image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
        rethrow;
      }
    }
    return downloadUrls;
  }

  Future<void> saveLostItemDetails(List<String> imageUrls) async {
    try {
      await itemDetails.add({
        'images': imageUrls,
        'date': DateTime.now().toString(),
        'floor': floorController.text,
        'class': classController.text,
        'founderEmail': founderEmailController.text,
        'founderUsn': founderUsnController.text,
        'founderName': founderNameController.text,
      });
      print('Details saved to Firestore'); // Debug print
    } catch (e) {
      print("Error saving details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving details: $e')),
      );
      rethrow;
    }
  }

  bool validateForm() {
    final floorRegExp = RegExp(r'^[1-9]$');
    final classRegExp = RegExp(r'^\d{3}$');
    final emailRegExp = RegExp(r'^[\w-\.]+@bmsce\.ac\.in$');
    final usnRegExp = RegExp(r'^1BM(2[2-9]|30)(CS|IS)\d{3}$');

    if (!floorRegExp.hasMatch(floorController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Floor should be a single digit, e.g., 1, 2.')),
      );
      return false;
    }
    if (classController.text.isNotEmpty &&
        !classRegExp.hasMatch(classController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Class should be a 3-digit number, e.g., 201, 305.')),
      );
      return false;
    }
    if (founderNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Founder\'s name is required.')),
      );
      return false;
    }
    if (!emailRegExp.hasMatch(founderEmailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Founder\'s email should end with @bmsce.ac.in')),
      );
      return false;
    }
    if (!usnRegExp.hasMatch(founderUsnController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Founder\'s USN format is invalid. Ex: 1BM22CS183, 1BM23IS263')),
      );
      return false;
    }
    return true;
  }

  void handleSubmit() async {
    if (!validateForm()) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<String> imageUrls = await uploadImages();
      await saveLostItemDetails(imageUrls);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item details saved successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost Item Bin Catalog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Photos', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: selectedImages.length < 4
                        ? () => pickImages(ImageSource.gallery)
                        : null,
                    icon: Icon(Icons.photo_library),
                    label: Text('From Gallery'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: selectedImages.length < 4
                        ? () => pickImages(ImageSource.camera)
                        : null,
                    icon: Icon(Icons.camera_alt),
                    label: Text('From Camera'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              selectedImages.isEmpty
                  ? Text('No images selected.')
                  : Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: selectedImages
                          .map((image) => Stack(
                                children: [
                                  Image.file(
                                    File(image.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImages.remove(image);
                                        });
                                      },
                                      child: Icon(Icons.remove_circle,
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
              SizedBox(height: 16),
              TextField(
                controller: founderNameController,
                decoration: InputDecoration(labelText: 'Founder\'s Name'),
              ),
              TextField(
                controller: founderEmailController,
                decoration: InputDecoration(labelText: 'Founder\'s Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: founderUsnController,
                decoration: InputDecoration(labelText: 'Founder\'s USN'),
              ),
              TextField(
                controller: floorController,
                decoration: InputDecoration(labelText: 'Floor'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: classController,
                decoration: InputDecoration(labelText: 'Class (Optional)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
