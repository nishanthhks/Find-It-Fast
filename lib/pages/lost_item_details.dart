import 'dart:io'; // Add this line to import the 'dart:io' package

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:lost_and_found_app/providers/lost_item_form_provider.dart';

class LostItemDetails extends StatefulWidget {
  const LostItemDetails({Key? key}) : super(key: key);

  @override
  LostItemDetailsState createState() => LostItemDetailsState();
}

class LostItemDetailsState extends State<LostItemDetails> {
  final ImagePicker _picker = ImagePicker();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<LostItemFormProvider>(context);

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
              const Text('Add Photos', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final List<XFile> pickedFiles =
                          await _picker.pickMultiImage() ?? [];
                      for (final file in pickedFiles) {
                        formProvider.addImage(file);
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('From Gallery'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final XFile? pickedFile =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        formProvider.addImage(pickedFile);
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('From Camera'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              formProvider.images.isEmpty
                  ? const Text('No images selected.')
                  : Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: formProvider.images
                          .asMap()
                          .entries
                          .map((entry) => Stack(
                                children: [
                                  Image.file(
                                    File(entry.value.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () =>
                                          formProvider.removeImage(entry.key),
                                      child: const Icon(Icons.remove_circle,
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 16),
              TextField(
                controller: myController,
                decoration: const InputDecoration(labelText: 'Floor'),
                onChanged: (value) => {print(myController.text.toString())},
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Room'),
                onChanged: (value) => formProvider.setRoom(value),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Person'),
                onChanged: (value) => formProvider.setPerson(value),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
