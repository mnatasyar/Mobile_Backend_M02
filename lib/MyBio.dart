import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'BioProv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBioProv extends StatelessWidget {
  const MyBioProv({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BioProv(),
      child: _MyBioProv(),
    );
  }
}

class _MyBioProv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bioProv = Provider.of<BioProv>(context);
    final _keyScore = "score";
    final _keyImage = "image";
    final _keyDate = "date";

    Future<void> _setScore(double value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble(_keyScore, value);
    }

    Future<void> _setImage(String imagePath) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_keyImage, imagePath);
    }

    Future<void> _setDate(DateTime date) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String formattedDate = DateFormat("yyyy-MM-dd").format(date);
      prefs.setString(_keyDate, formattedDate);
    }

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
                child: bioProv.image != null
                    ? Image.file(
                        File(bioProv.image!),
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
                        await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      String imagePath = image.path;
                      bioProv.setImage(imagePath);
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
                  value: bioProv.score,
                  decimals: 1,
                  step: 0.1,
                  decoration: InputDecoration(labelText: 'Skor'),
                  onChanged: (value) {
                    bioProv.setScore(value);
                    _setScore(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: bioProv.date ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      bioProv.setDate(selectedDate);
                      _setDate(selectedDate);
                    }
                  },
                  child: Text("Pilih Tanggal"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  bioProv.date != null
                      ? "Tanggal dipilih: ${DateFormat('yyyy-MM-dd').format(bioProv.date!)}"
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