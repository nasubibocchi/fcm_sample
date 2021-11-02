import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreModel {
  final firestore = FirebaseFirestore.instance;

  Future<void> saveFcmToken({required String token}) async {
    final collectionRef = firestore.collection('users');

    if (collectionRef.doc(token).path.isEmpty) {
      await collectionRef.doc(token).set(<String, dynamic>{
        'fcmToken': token,
        'createdAt' : DateTime.now(),
      });
    } else {
      await collectionRef.doc(token).update(<String, dynamic>{
        'fcmToken': token,
        'createdAt' : DateTime.now(),
      });
    }
  }

  Future<void> addPost2FireStore({required token, text}) async {
    text ?? ' ';

    final collectionRef =
        firestore.collection('users').doc(token).collection('post');
    await collectionRef.add(<String, dynamic>{
      'text': text,
    });
  }

}
