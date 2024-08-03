import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(Map<String, dynamic> blogData) async {
    try {
      await FirebaseFirestore.instance.collection("blogs").add(blogData);
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance.collection("blogs").snapshots();
  }
}
