import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register/db_helper/db_functions.dart';
import 'package:register/db_model/db_model.dart';
import 'package:register/screens/home.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userAgeController = TextEditingController();
  final _userDomainController = TextEditingController();
  final _userContactController = TextEditingController();

  File? _image;
  bool _validateName = false;
  bool _validateAge = false;
  bool _validateDomain = false;
  bool _validateContact = false;

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

  void clear() {
    setState(() {
      _userNameController.clear();
      _userAgeController.clear();
      _userDomainController.clear();
      _userContactController.clear();
      _image = null;
      _validateName = false;
      _validateAge = false;
      _validateDomain = false;
      _validateContact = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STUDENT RECORD'),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    errorText: _validateName ? 'Name cannot be empty' : null,
                    errorBorder: _validateName
                        ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                        : null,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() => _validateName = true);
                      return 'Name cannot be empty';
                    }
                    setState(() => _validateName = false);
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userAgeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Age',
                    labelText: 'Age',
                    errorText: _validateAge ? 'Age cannot be empty' : null,
                    errorBorder: _validateAge
                        ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                        : null,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() => _validateAge = true);
                      return 'Age cannot be empty';
                    }
                    setState(() => _validateAge = false);
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userDomainController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Domain',
                    labelText: 'Domain',
                    errorText: _validateDomain ? 'Domain cannot be empty' : null,
                    errorBorder: _validateDomain
                        ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                        : null,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() => _validateDomain = true);
                      return 'Domain cannot be empty';
                    }
                    setState(() => _validateDomain = false);
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userContactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Contact Number',
                    labelText: 'Contact Number',
                    errorText: _validateContact ? 'Contact number cannot be empty' : null,
                    errorBorder: _validateContact
                        ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                        : null,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() => _validateContact = true);
                      return 'Contact number cannot be empty';
                    }
                    setState(() => _validateContact = false);
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && _image != null) {
                          final name1 = _userNameController.text;
                          final age1 = _userAgeController.text;
                          final domain1 = _userDomainController.text;
                          final contact1 = _userContactController.text;
                          final img = _image;

                          final value = StudentModel(
                            name: name1,
                            age: age1,
                            domain: domain1,
                            contact: contact1,
                            imagePath: img!.path.toString(),
                          );

                          addUser(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data saved successfully'),backgroundColor: Colors.blue),
                          );
                          clear();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const Home()),
                          );
                        } else if (_image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Image should be added'),backgroundColor: Colors.red),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all required fields'),backgroundColor: Colors.red),
                          );
                          setState(() {
                            _validateName = _userNameController.text.isEmpty;
                            _validateAge = _userAgeController.text.isEmpty;
                            _validateDomain = _userDomainController.text.isEmpty;
                            _validateContact = _userContactController.text.isEmpty;
                          });
                        }
                      },
                      child: const Text('Save Details'),
                    ),
                    const SizedBox(width: 120),
                    ElevatedButton(
                      onPressed: () {
                        clear();
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
}
