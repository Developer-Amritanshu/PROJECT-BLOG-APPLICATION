import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> adddata(blogdata) async {
    Firestore.instance.collection("blogs").add(blogdata).catchError((e) {
      print(e);
    });
  }

  getData() async{
    return await Firestore.instance.collection("blogs").snapshots();
  }
}
