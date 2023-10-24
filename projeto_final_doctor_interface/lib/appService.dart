// ignore_for_file: file_names, unused_field
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _doctors =
      FirebaseFirestore.instance.collection('Doctors');
  Map? _doctorData;
  final CollectionReference _patients =
      FirebaseFirestore.instance.collection('Patients');
  Map? _patientData;
  final CollectionReference _tests =
      FirebaseFirestore.instance.collection('Tests');
  Map? _testData;

  AppService(FirebaseAuth instance);

  //Serviço de autenticação
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot query =
          await _doctors.where('email', isEqualTo: email).get();
      QueryDocumentSnapshot doc = query.docs[0];

      await setDoctorData(doc['name'], doc['cpf'], doc['crm'], email,
          doc['password'], doc['admin']);

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  //Serviço de deslogar
  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> fetchDoctorData() async {
    String? email = auth.currentUser!.email;

    QuerySnapshot query = await _doctors.where('email', isEqualTo: email).get();
    QueryDocumentSnapshot docDoctors = query.docs[0];

    await setDoctorData(docDoctors['name'], docDoctors['cpf'],
        docDoctors['crm'], email!, docDoctors['password'], docDoctors['admin']);
  }

  Future<void> setDoctorData(String name, String cpf, String crm, String email,
      String password, bool admin) async {
    _doctorData = {
      'name': name,
      'cpf': cpf,
      'crm': crm,
      'email': email,
      'password': password,
      'admin': admin
    };
  }

  Future<String> doctorRegistration(String name, String cpf, String crm,
      String email, String password, bool admin) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.currentUser!.updateDisplayName(name);
      await _doctors.add({
        'name': name,
        'cpf': cpf,
        'crm': crm,
        'email': email,
        'password': password,
        'adm': admin
      });

      await setDoctorData(name, cpf, crm, email, password, admin);

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
      List<String> testesRealizados) async {
    _patientData = {
      'name': name,
      'cpf': cpf,
      'medicalRecordNumber': medicalRecordNumber,
      'gender': gender,
      'birthdate': birthdate,
      'testesRealizados': testesRealizados
    };
  }

  Future<String> patientRegistration(
      String name,
      String cpf,
      String medicalRecordNumber,
      String gender,
      String birthdate,
      List<String> testesRealizados) async {
    try {
      await _patients.add({
        'name': name,
        'cpf': cpf,
        'medicalRecordNumber': medicalRecordNumber,
        'gender': gender,
        'birthdate': birthdate,
        'testesRealizados': testesRealizados
      });

      await setPatientData(
          name, cpf, medicalRecordNumber, gender, birthdate, testesRealizados);

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
      List<String> imageCube,
      List<String> imageClock,
      List<String> imagePoints) async {
    _testData = {
      'patientName': patientId,
      'doctorName': doctorName,
      'testStarted': testStarted,
      'testFinished': testFinished,
      'date': date,
      'imageCube': imageCube,
      'imageClock': imageClock,
      'imagePoints': imagePoints
    };
  }

  Future<String> createTest(
      String patientId,
      String doctorName,
      bool testStarted,
      bool testFinished,
      DateTime date,
      List<String> imageCube,
      List<String> imageClock,
      List<String> imagePoints) async {
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
        'imagePoints': imagePoints
      });
      String testId = testRef.id;
      // Atualize a lista de testes realizados do paciente
      DocumentReference patientRef =
          FirebaseFirestore.instance.collection('Patients').doc(patientId);
      await patientRef.update({
        'testesRealizados': FieldValue.arrayUnion([testId]),
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
        return null; // Retorna null se nenhum teste não finalizado for encontrado.
      }
    } catch (error) {
      print(error);
      return null; // Trate o erro de acordo com suas necessidades.
    }
  }
}
