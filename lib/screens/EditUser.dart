import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register/db_helper/db_functions.dart';
import 'package:register/db_model/db_model.dart';
import 'package:register/screens/home.dart';

class Edituser extends StatefulWidget {
  final StudentModel students;

  const Edituser({Key? key, required this.students}) : super(key: key);

  @override
  State<Edituser> createState() => _EditUserState();
}

class _EditUserState extends State<Edituser> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userAgeController = TextEditingController();
  final _userDomainController = TextEditingController();
  final _userContactController = TextEditingController();

  File? _image;

  @override
  void initState() {
    super.initState();
    _userNameController.text = widget.students.name;
    _userAgeController.text = widget.students.age.toString();
    _userDomainController.text = widget.students.domain.toString();
    _userContactController.text = widget.students.contact.toString();
    _image = File(widget.students.imagePath ?? '');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateStudentInfo() async {
    if (_formKey.currentState!.validate()) {
      
      final name1 = _userNameController.text;
      final age1 = _userAgeController.text;
      final domain1 = _userDomainController.text;
      final contact1 = _userContactController.text;
      final img = _image;

      final updatedStudent = StudentModel(
        id: widget.students.id, 
        name: name1,
        age: age1,
        domain: domain1,
        contact: contact1,
        imagePath: _image!.path.toString(),
      );

      final result = await updateStudent(updatedStudent, widget.students.id!);
      if (result != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully'),backgroundColor: Colors.red),
        );
        Navigator.pop(context);
        clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update data'),backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student Record'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.blue,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 100,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userAgeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Age',
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Age cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userDomainController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Domain',
                    labelText: 'Domain',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Domain cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userContactController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Contact Number',
                    labelText: 'Contact Number',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Contact number cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: updateStudentInfo,
                      child: const Text('Update Details'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        clear();
                        setState(() {
                          _image = null;
                        });
                      },
                      child: const Text('Clear Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    setState(() {
      _userNameController.clear();
      _userAgeController.clear();
      _userDomainController.clear();
      _userContactController.clear();
      _image = null;
    });
  }
}
