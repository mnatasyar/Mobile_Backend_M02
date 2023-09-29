import 'package:flutter/material.dart';

class BioProv extends ChangeNotifier {
  String? _image;
  double _score = 0;
  DateTime? _date;

  String? get image => _image;
  double get score => _score;
  DateTime? get date => _date;

  void setImage(String imagePath) {
    _image = imagePath;
    notifyListeners();
  }

  void setScore(double value) {
    _score = value;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    _date = date;
    notifyListeners();
  }
}