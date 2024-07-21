import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class LostItemDetailsPage extends StatefulWidget {
  @override
  _LostItemDetailsPageState createState() => _LostItemDetailsPageState();
}

class _LostItemDetailsPageState extends State<LostItemDetailsPage> {
  final CollectionReference itemDetails = FirebaseFirestore.instance.collection('lost_items');
  final ImagePicker _picker = ImagePicker();

  final TextEditingController floorController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController finderNameController = TextEditingController();
  final TextEditingController finderUsnController = TextEditingController();
  final TextEditingController finderEmailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<XFile> selectedImages = [];
  bool isLoading = false;

  Future<void> pickImages(ImageSource source) async {
    try {
      final List<XFile>? pickedFiles = source == ImageSource.gallery
          ? await _picker.pickMultiImage()
          : [(await _picker.pickImage(source: source))!];

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        if (selectedImages.length + pickedFiles.length <= 3) {
          setState(() {
            selectedImages.addAll(pickedFiles);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only select up to 3 images.')),
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
            .child(finderUsnController.text)
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
      DateTime now = DateTime.now();
      String daySuffix = _getDaySuffix(now.day);
      String formattedDate = DateFormat('d').format(now) +
          daySuffix +
          ' ' +
          DateFormat('MMMM yyyy, EEEE, h:mm a').format(now);

      await itemDetails.add({
        'images': imageUrls,
        'date': formattedDate,
        'floor': floorController.text,
        'class': classController.text,
        'finderEmail': finderEmailController.text,
        'finderUsn': finderUsnController.text,
        'finderName': finderNameController.text,
        'description': descriptionController.text,
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

  String _getDaySuffix(int day) {
    if (day % 10 == 1 && day != 11) {
      return 'st';
    } else if (day % 10 == 2 && day != 12) {
      return 'nd';
    } else if (day % 10 == 3 && day != 13) {
      return 'rd';
    } else {
      return 'th';
    }
  }

  bool validateForm() {
    final floorRegExp = RegExp(r'^[1-9]$');
    final classRegExp = RegExp(r'^\d{3}$');
    final emailRegExp = RegExp(r'^[\w-\.]+@bmsce\.ac\.in$');
    final usnRegExp = RegExp(r'^1BM(2[2-9]|30)(CS|IS)\d{3}$');
    final descriptionRegExp = RegExp(r'(\w+)', multiLine: true);

    if (!floorRegExp.hasMatch(floorController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Floor should be a single digit, e.g., 1, 2.')),
      );
      return false;
    }
    if (classController.text.isNotEmpty &&
        !classRegExp.hasMatch(classController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class should be a 3-digit number, e.g., 201, 305.')),
      );
      return false;
    }
    if (finderNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finder\'s name is required.')),
      );
      return false;
    }
    if (!emailRegExp.hasMatch(finderEmailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finder\'s email should end with @bmsce.ac.in')),
      );
      return false;
    }
    if (!usnRegExp.hasMatch(finderUsnController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finder\'s USN format is invalid. Ex: 1BM22CS183, 1BM23IS263')),
      );
      return false;
    }
    if (descriptionController.text.trim().split(RegExp(r'\s+')).length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description should be limited to 50 words.')),
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
        const SnackBar(content: Text('Item details saved successfully!')),
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
        title: const Text('Lost Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Add Photos'),
              const SizedBox(height: 8),
              ImagePickerRow(
                pickImages: pickImages,
                selectedImages: selectedImages,
              ),
              const SizedBox(height: 16),
              selectedImages.isEmpty
                  ? const Text('No images selected.',
                      style: TextStyle(color: Colors.black))
                  : SelectedImagesGrid(
                      selectedImages: selectedImages,
                      onRemove: (image) {
                        setState(() {
                          selectedImages.remove(image);
                        });
                      },
                    ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: finderNameController,
                label: 'Finder\'s Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: finderEmailController,
                label: 'Finder\'s Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: finderUsnController,
                label: 'Finder\'s USN',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: floorController,
                label: 'Floor',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: classController,
                label: 'Class (Optional)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                label: 'Description',
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: handleSubmit,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: const Text('Submit'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, color: Colors.black),
    );
  }
}

class ImagePickerRow extends StatelessWidget {
  final Function(ImageSource) pickImages;
  final List<XFile> selectedImages;

  const ImagePickerRow({required this.pickImages, required this.selectedImages});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: selectedImages.length < 3
              ? () => pickImages(ImageSource.gallery)
              : null,
          icon: const Icon(Icons.photo_library),
          label: const Text('From Gallery',
              style: TextStyle(fontSize: 15, color: Colors.black)),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: selectedImages.length < 3
              ? () => pickImages(ImageSource.camera)
              : null,
          icon: const Icon(Icons.camera_alt),
          label: const Text('From Camera',
              style: TextStyle(fontSize: 15, color: Colors.black)),
        ),
      ],
    );
  }
}

class SelectedImagesGrid extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function(XFile) onRemove;

  const SelectedImagesGrid({required this.selectedImages, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
                      onTap: () => onRemove(image),
                      child: const Icon(Icons.remove_circle, color: Colors.red),
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
