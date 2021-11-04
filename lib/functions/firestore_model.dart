import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreModel {
  final firestore = FirebaseFirestore.instance;

  Future<void> saveFcmToken({String? token}) async {
    final collectionRef = firestore.collection('users');
    final snapshot = await collectionRef.where('fcmToken', isEqualTo: token).get();
    final doc = snapshot.docs;

    if (doc.isEmpty) {
      await collectionRef.doc(token).set(<String, dynamic>{
        'fcmToken': token,
      });
    }
  }

  Future<void> addPost2FireStore({required token, text}) async {
    text ?? ' ';

    final collectionRef =
        firestore.collection('users').doc(token).collection('post');
    await collectionRef.add(<String, dynamic>{
      'text': text,
      'createdAt': DateTime.now(),
      'fcmToken' : token,
    });
  }
}
