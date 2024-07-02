import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:register/db_model/db_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
late Database _db;

Future<void> initializeDataBase() async {
  _db = await openDatabase('students.db', version: 1, onCreate: (Database db, int version) async {
    await db.execute(
        'CREATE TABLE students (id INTEGER PRIMARY KEY , name TEXT, age TEXT, domain TEXT, contact TEXT, imagePath TEXT)');
  }
  );}

Future<void> addUser(StudentModel value) async {
  try {
    print('Adding Student: $value');
    await _db.rawInsert(
      'INSERT INTO students (name, age, domain, contact, imagePath) VALUES(?,?,?,?,?)',
      [value.name, value.age, value.domain, value.contact, value.imagePath],
    );
    await getAllStudents();
  } catch (e) {
    print('Error adding student: $e');
  }
}

Future<void> getAllStudents() async { 
  final values = await _db.rawQuery('SELECT * FROM students');
  print(values);
  studentListNotifier.value.clear();

  values.forEach((map){
    final students = StudentModel.fromMap(map);
    studentListNotifier.value.add(students);
  studentListNotifier.notifyListeners();

  });
}


Future<List<Map<String, Object?>>> updateStudent(
   StudentModel value, int id) async {
     print(value);
  final result = await _db.rawQuery(
      'UPDATE students SET name = ?, age = ?,domain=?,contact=?,imagePath=? WHERE id = ?',
        [
        value.name,
        value.age,
        value.domain,
        value.contact,
        value.imagePath,
        value.id
      ]);
      await getAllStudents();
       return result;
  
   }

Future<void> deleteId(int id) async {
  await _db.rawDelete('DELETE FROM students WHERE id=?', [id]);
  await getAllStudents();
}
