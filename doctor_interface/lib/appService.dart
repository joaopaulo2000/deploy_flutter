// ignore_for_file: file_names, unused_field
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final_doctor_interface/view/loginpage.dart';

class AppService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference doctors =
      FirebaseFirestore.instance.collection('Doctors');
  Map? doctorData;
  final CollectionReference patients =
      FirebaseFirestore.instance.collection('Patients');
  Map? patientData;
  final CollectionReference tests =
      FirebaseFirestore.instance.collection('Tests');
  Map? testData;

  AppService(FirebaseAuth instance);

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot query =
          await doctors.where('email', isEqualTo: email).get();
      QueryDocumentSnapshot doc = query.docs[0];

      await setDoctorData(
          doc['name'], doc['cpf'], doc['crm'], email, doc['password']);

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  Future<void> signOut(context) async {
    await auth.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
      builder: (context) =>
      const LoginPage()));
  }  


  Future<void> fetchDoctorData() async {
    String? email = auth.currentUser!.email;

    QuerySnapshot query = await doctors.where('email', isEqualTo: email).get();
    QueryDocumentSnapshot docDoctors = query.docs[0];

    await setDoctorData(docDoctors['name'], docDoctors['cpf'],
        docDoctors['crm'], email!, docDoctors['password']);
  }

  Future<void> setDoctorData(String name, String cpf, String crm, String email,
      String password) async {
    doctorData = {
      'name': name,
      'cpf': cpf,
      'crm': crm,
      'email': email,
      'password': password
    };
  }

  Future<String> doctorRegistration(String name, String cpf, String crm,
      String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.currentUser!.updateDisplayName(name);
      await doctors.add({
        'name': name,
        'cpf': cpf,
        'crm': crm,
        'email': email,
        'password': password
      });

      await setDoctorData(name, cpf, crm, email, password);

      return 'Signed Up';
    } catch (error) {
      return '$error';
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> setPatientData(
      String name,
      String cpf,
      String medicalRecordNumber,
      String gender,
      String birthdate,
      List<String> testsDone) async {
    patientData = {
      'name': name,
      'cpf': cpf,
      'medicalRecordNumber': medicalRecordNumber,
      'gender': gender,
      'birthdate': birthdate,
      'testsDone': testsDone
    };
  }

  Future<String> patientRegistration(
      String name,
      String cpf,
      String medicalRecordNumber,
      String gender,
      String birthdate,
      List<String> testsDone) async {
    try {
      await patients.add({
        'name': name,
        'cpf': cpf,
        'medicalRecordNumber': medicalRecordNumber,
        'gender': gender,
        'birthdate': birthdate,
        'testsDone': testsDone
      });

      await setPatientData(
          name, cpf, medicalRecordNumber, gender, birthdate, testsDone);

      return 'Signed Up';
    } catch (error) {
      return '$error';
    }
  }

  String? getDoctorName() {
    return auth.currentUser!.displayName;
  }

  Future<void> setTestData(
      String patientId,
      String doctorName,
      bool testStarted,
      bool testFinished,
      DateTime date,
      String imageCube,
      String imageClock,
      String imagePoints,
      String namingOne,
      String namingTwo,
      String namingThree,
      String scoreOne,
      String scoreTwo,
      String scoreThreePartOne,
      String scoreThreePartTwo,
      String scoreThreePartThree,
      String scoreFourPartOne,
      String scoreFourPartTwo,
      String scoreFive,
      String scoreSix,
      String scoreSeven,
      String finalScore,
      String obs,
      List<String> times) async {
    testData = {
      'patientName': patientId,
      'doctorName': doctorName,
      'testStarted': testStarted,
      'testFinished': testFinished,
      'date': date,
      'imageCube': imageCube,
      'imageClock': imageClock,
      'imagePoints': imagePoints,
      'namingOne': namingOne,
      'namingTwo': namingTwo,
      'namingThree': namingThree,
      'scoreOne': scoreOne,
      'scoreTwo': scoreTwo,
      'scoreThreePartOne': scoreThreePartOne,
      'scoreThreePartTwo': scoreThreePartTwo,
      'scoreThreePartThree': scoreThreePartThree,
      'scoreFourPartOne': scoreFourPartOne,
      'scoreFourPartTwo': scoreFourPartTwo,
      'scoreFive': scoreFive,
      'scoreSix': scoreSix,
      'scoreSeven': scoreSeven,
      'finalScore': finalScore,
      'obs': obs,
      'times': times,
    };
  }

  Future<String> createTest(
    String patientId,
    String doctorName,
    bool testStarted,
    bool testFinished,
    DateTime date,
    String imageCube,
    String imageClock,
    String imagePoints,
    String namingOne,
    String namingTwo,
    String namingThree,
    String scoreOne,
    String scoreTwo,
    String scoreThreePartOne,
    String scoreThreePartTwo,
    String scoreThreePartThree,
    String scoreFourPartOne,
    String scoreFourPartTwo,
    String scoreFive,
    String scoreSix,
    String scoreSeven,
    String finalScore,
    String obs,
    List<String> times,
  ) async {
    try {
      DocumentReference testRef =
          await FirebaseFirestore.instance.collection('Tests').add({
        'patientId': patientId,
        'doctorName': doctorName,
        'testStarted': testStarted,
        'testFinished': testFinished,
        'date': date,
        'imageCube': imageCube,
        'imageClock': imageClock,
        'imagePoints': imagePoints,
        'namingOne': namingOne,
        'namingTwo': namingTwo,
        'namingThree': namingThree,
        'scoreOne': scoreOne,
        'scoreTwo': scoreTwo,
        'scoreThreePartOne': scoreThreePartOne,
        'scoreThreePartTwo': scoreThreePartTwo,
        'scoreThreePartThree': scoreThreePartThree,
        'scoreFourPartOne': scoreFourPartOne,
        'scoreFourPartTwo': scoreFourPartTwo,
        'scoreFive': scoreFive,
        'scoreSix': scoreSix,
        'scoreSeven': scoreSeven,
        'finalScore': finalScore,
        'obs': obs,
        'times': times
      });

      String testId = testRef.id;
      DocumentReference patientRef =
          FirebaseFirestore.instance.collection('Patients').doc(patientId);

      await patientRef.update({
        'testsDone': FieldValue.arrayUnion([testId]),
      });

      return 'Test created';
    } catch (error) {
      return '$error';
    }
  }

  Future<String?> getLatestUnfinishedTestId() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tests')
          .where('testFinished', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot latestTest = querySnapshot.docs.first;
        return latestTest.id;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<String?> getPatientName(testId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Tests')
              .doc(testId)
              .get();

      String patientId = documentSnapshot['patientId'];
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshotTwo =
          await FirebaseFirestore.instance
              .collection('Patients')
              .doc(patientId)
              .get();
      String patientName = documentSnapshotTwo['name'];
      return patientName;
    } catch (error) {
      return null;
    }
  }
}
