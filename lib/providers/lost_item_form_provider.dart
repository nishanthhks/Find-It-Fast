import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LostItemFormProvider with ChangeNotifier {
  List<XFile> _images = [];
  String _floor = '';
  String _room = '';
  String _person = '';

  List<XFile> get images => _images;
  String get floor => _floor;
  String get room => _room;
  String get person => _person;

  void addImage(XFile image) {
    _images.add(image);
    notifyListeners();
  }

  void setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  void setRoom(String room) {
    _room = room;
    notifyListeners();
  }

  void setPerson(String person) {
    _person = person;
    notifyListeners();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }
}
