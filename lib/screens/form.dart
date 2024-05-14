// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pemograman_mobile_2255011004/main.dart';

import 'dart:async';
import 'dart:convert';

import 'package:pemograman_mobile_2255011004/models/customer_service_model.dart';
import 'package:pemograman_mobile_2255011004/models/department_model.dart';
import 'package:pemograman_mobile_2255011004/models/priority_issue_model.dart';
import 'package:pemograman_mobile_2255011004/services/api_services.dart';

class FormData extends StatefulWidget {
  final CustomerService? customer;
  const FormData({this.customer, super.key});

  @override
  _FormDataState createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title_issues = '';
  String _description_issues = '';
  int _rating = 0;
  String _fotoPath = '';
  int _id_division_target = 0;
  int _id_priority = 0;

  final APiService apiService = APiService();

  // Tambahkan variabel untuk menyimpan daftar kelompok tani
  PriortyIssue? _selectedPriority;
  List<PriortyIssue> _Priority_list = [];
  DivisionDepartment? _selectedDepartment;
  List<DivisionDepartment> _Department_List = [];

  // Metode untuk memilih foto
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _fotoPath = pickedFile.path;
      });
    }
  }

  // Method untuk memilih gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        // Ubah nilai fotoController sesuai dengan gambar yang dipilih dari galeri
        _fotoPath = pickedImage.path;
      });
    }
  }

  // method untuk fetching data kelompok tani
  Future<void> _fetchDataPriority() async {
    try {
      final response = await http
          .get(Uri.parse('https://simobile.singapoly.com/api/priority-issues'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var datas = jsonData['datas']
            as List; // Mengakses properti 'datas' dari objek JSON
        print(datas);
        setState(() {
          _Priority_list =
              datas.map((item) => PriortyIssue.fromJson(item)).toList();
          if (widget.customer != null) {
            _selectedPriority = _Priority_list.firstWhere(
              (kelompok) => kelompok.idPriority == widget.customer!.idPriority,
              orElse: () => _Priority_list.first,
            );
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // method get Department
  Future<void> _fetchDataDepartment() async {
    try {
      final response = await http.get(
          Uri.parse('https://simobile.singapoly.com/api/division-department'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var datas = jsonData['datas']
            as List; // Mengakses properti 'datas' dari objek JSON
        print(datas);
        setState(() {
          _Department_List =
              datas.map((item) => DivisionDepartment.fromJson(item)).toList();
          if (widget.customer != null) {
            _selectedDepartment = _Department_List.firstWhere(
              (kelompok) =>
                  kelompok.idDivisionTarget ==
                  widget.customer!.idDivisionTarget,
              orElse: () => _Department_List.first,
            );
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _saveData() async {
    try {
      if (widget.customer == null) {
        // Menambahkan data baru
        await APiService.saveData(
          CustomerService(
            titleIssue: _title_issues,
            descriptionIssues: _description_issues,
            rating: _rating,
            idDivisionTarget: _id_division_target,
            idPriority: _id_priority,
          ),
          _fotoPath,
        );
        Fluttertoast.showToast(
          msg: 'Data berhasil ditambahkan',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        // Mengedit data yang sudah ada
        // await APiService.editDataWithFile(
        //   widget.petani?.idPenjual,
        //   ClassTemplate(
        //     // idPenjual: widget.petani?.idPenjual,
        //     idKelompokTani: _idKelompok,
        //     nama: _nama,
        //     nik: _nik,
        //     alamat: _alamat,
        //     telp: _telp,
        //     status: _status,
        //   ),
        //   _fotoPath,
        // );
        Fluttertoast.showToast(
          msg: 'Data berhasil diperbarui',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
      // Kembali ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // _fetchKelompokTani();
    // print(_kelompokList);

    _fetchDataPriority();
    _fetchDataDepartment();

    // print(widget.petani?.foto);
    // Jika petani diberikan, isi nilai-nilai default dari petani
    if (widget.customer != null) {
      _title_issues = widget.customer!.titleIssue ?? '';
      _description_issues = widget.customer!.descriptionIssues ?? '';
      _rating = widget.customer!.rating ?? 0;
      _id_division_target = widget.customer!.idDivisionTarget!;
      _id_priority = widget.customer!.idPriority!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null
            ? 'Input Form Customer'
            : 'Edit Form Customer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title_issues,
                decoration: const InputDecoration(labelText: 'Title Issues'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title Issue tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (newValue) => _title_issues = newValue!,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                initialValue: _description_issues,
                decoration:
                    const InputDecoration(labelText: 'Description Issues'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description Issues tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (newValue) => _description_issues = newValue!,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                initialValue:
                    _rating.toString(), // Konversi nilai int menjadi String
                keyboardType: TextInputType
                    .number, // Tambahkan keyboard type untuk memastikan input bertipe angka
                decoration: const InputDecoration(labelText: 'Rating'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rating tidak boleh kosong';
                  }
                  // Validasi apakah nilai dapat diubah menjadi int
                  if (int.tryParse(value) == null) {
                    return 'Rating harus berupa angka';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  // Ubah nilai yang diterima dari String menjadi int sebelum disimpan
                  _rating = int.parse(newValue!);
                },
              ),
              const SizedBox(height: 20.0),
              // Dropdown untuk Priority
              DropdownButtonFormField<PriortyIssue>(
                value: _selectedPriority,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                    _id_priority = newValue!.idPriority as int;
                  });
                },
                items: _Priority_list.map<DropdownMenuItem<PriortyIssue>>(
                  (PriortyIssue priority) {
                    return DropdownMenuItem<PriortyIssue>(
                      value: priority,
                      child: Text('${priority.priorityName}'),
                    );
                  },
                ).toList(),
                decoration: const InputDecoration(
                  labelText: 'Priorty issue',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih Priorty issue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Dropdown untuk Department
              DropdownButtonFormField<DivisionDepartment>(
                value: _selectedDepartment,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartment = newValue;
                    _id_priority = newValue!.idDivisionTarget as int;
                  });
                },
                items:
                    _Department_List.map<DropdownMenuItem<DivisionDepartment>>(
                  (DivisionDepartment department) {
                    return DropdownMenuItem<DivisionDepartment>(
                      value: department,
                      child: Text('${department.divisionDepartmentName}'),
                    );
                  },
                ).toList(),
                decoration: const InputDecoration(
                  labelText: 'Department Name',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih Department Name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20.0),
              _fotoPath != ''
                  ? Image.file(
                      // Menampilkan gambar yang dipilih
                      File(_fotoPath),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            Text('Gambar tidak dapat diakses'),
                          ],
                        );
                      },
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey,
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),

              const SizedBox(height: 20.0),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: _pickImageFromGallery,
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      initialValue: _fotoPath,
                      decoration: const InputDecoration(
                        labelText: 'Foto',
                      ),
                      // controller: TextEditingController(text: _fotoPath),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_camera),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // _formKey.currentState!.save();
                  // // _submitForm();
                  // _saveData();
                },
                child: Text(widget.customer == null ? 'Submit' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
