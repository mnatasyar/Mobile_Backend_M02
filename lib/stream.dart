import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  _MyBioState createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  String? _image;
  double _score = 0;
  final ImagePicker _picker = ImagePicker();
  final String _keyScore = "score";
  final String _keyImage = "image";
  final String _keyDate = "date"; // Tambahkan kunci tanggal
  DateTime? _date; // Tambahkan variabel tanggal
  late SharedPreferences prefs;

  Future<void> _setScore(double value) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble(_keyScore, value);
      _score = prefs.getDouble(_keyScore) ?? 0;
    });
  }

  Future<void> _setImage(String imagePath) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(_keyImage, imagePath);
      _image = imagePath;
    });
  }

  Future<void> _setDate(DateTime date) async {
    prefs = await SharedPreferences.getInstance();
    final formattedDate = DateFormat("yyyy-MM-dd").format(date);
    setState(() {
      prefs.setString(_keyDate, formattedDate);
      _date = date;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = prefs.getDouble(_keyScore) ?? 0;
      _image = prefs.getString(_keyImage);
      final storedDate = prefs.getString(_keyDate);
      _date = storedDate != null ? DateTime.parse(storedDate) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                        File(_image!),
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 198, 198, 198)),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      String imagePath = image.path;
                      _setImage(imagePath);
                    }
                  },
                  child: Text("Ambil Gambar"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinBox(
                  max: 10.0,
                  min: 0.0,
                  value: _score,
                  decimals: 1,
                  step: 0.1,
                  decoration: InputDecoration(labelText: 'Skor'),
                  onChanged: _setScore,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _date ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _setDate(selectedDate);
                      });
                    }
                  },
                  child: Text("Pilih Tanggal"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _date != null
                      ? "Tanggal dipilih: ${DateFormat('yyyy-MM-dd').format(_date!)}"
                      : "Belum ada tanggal dipilih"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}