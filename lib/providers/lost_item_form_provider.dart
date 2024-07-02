import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LostItemFormProvider extends ChangeNotifier {
  List<XFile> _images = [];
  String _floor = '';
  String _class = '';
  String _founderName = '';
  String _founderUsn = '';

  List<XFile> get images => _images;
  String get floor => _floor;
  String get class_ => _class; // Use 'class_' instead of 'class' as 'class' is a reserved keyword
  String get founderName => _founderName;
  String get founderUsn => _founderUsn;

  void addImage(XFile image) {
    if (_images.length < 4) {
      _images.add(image);
      notifyListeners();
    }
  }

  void updateImage(int index, XFile newImage) {
    if (index >= 0 && index < _images.length) {
      _images[index] = newImage;
      notifyListeners();
    }
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void setFloor(String value) {
    _floor = value;
    notifyListeners();
  }

  void setClass(String value) {
    _class = value;
    notifyListeners();
  }

  void setFounderName(String value) {
    _founderName = value;
    notifyListeners();
  }

  void setFounderUsn(String value) {
    _founderUsn = value;
    notifyListeners();
  }

  bool isFormValid(String floor, String class_, String founderName, String founderUsn) {
    return floor.isNotEmpty && founderName.isNotEmpty && founderUsn.isNotEmpty;
  }
}
