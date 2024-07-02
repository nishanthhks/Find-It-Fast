import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:lost_and_found_app/providers/lost_item_form_provider.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class LostItemDetailsPage extends StatefulWidget {
  const LostItemDetailsPage({Key? key}) : super(key: key);

  @override
  LostItemDetailsState createState() => LostItemDetailsState();
}

class LostItemDetailsState extends State<LostItemDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController founderNameController = TextEditingController();
  final TextEditingController founderUsnController = TextEditingController();

  late DateTime currentDateTime;

  @override
  void initState() {
    super.initState();
    currentDateTime = DateTime.now();
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

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
                    onPressed: formProvider.images.length >= 4
                        ? null
                        : () async {
                            final List<XFile> pickedFiles =
                                await _picker.pickMultiImage() ?? [];
                            for (final file in pickedFiles) {
                              if (formProvider.images.length < 4) {
                                formProvider.addImage(file);
                              }
                            }
                          },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('From Gallery'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: formProvider.images.length >= 4
                        ? null
                        : () async {
                            final XFile? pickedFile =
                                await _picker.pickImage(
                                    source: ImageSource.camera);
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
                          .map((entry) => GestureDetector(
                                onTap: () async {
                                  final XFile? pickedFile = await _picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    formProvider.updateImage(
                                        entry.key, pickedFile);
                                  }
                                },
                                child: Stack(
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
                                ),
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 16),
              TextField(
                controller: floorController,
                decoration: const InputDecoration(labelText: 'Floor'),
                onChanged: (value) => formProvider.setFloor(value),
              ),
              TextField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Class'),
                onChanged: (value) => formProvider.setClass(value),
              ),
              TextField(
                controller: founderNameController,
                decoration: const InputDecoration(labelText: 'Founder\'s Name'),
                onChanged: (value) => formProvider.setFounderName(value),
              ),
              TextField(
                controller: founderUsnController,
                decoration: const InputDecoration(labelText: 'Founder\'s USN'),
                onChanged: (value) => formProvider.setFounderUsn(value),
              ),
              const SizedBox(height: 16),
              Text('Date: ${formatDate(currentDateTime)}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Time: ${formatTime(currentDateTime)}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formProvider.isFormValid(
                      floorController.text,
                      classController.text,
                      founderNameController.text,
                      founderUsnController.text)) {
                    Navigator.pushReplacementNamed(
                        context, MyRouts.adminHomeRoute);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields except Class.'),
                      ),
                    );
                  }
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
