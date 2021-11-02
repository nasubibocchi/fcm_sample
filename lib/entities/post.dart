import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? text;
  DateTime? createdAt;
  DocumentReference? documentReference;

  Post (DocumentSnapshot doc) {
    Map<String, dynamic> extracted = doc.data() as Map<String, dynamic>;
    text = extracted['text'];
    createdAt = extracted['createdAt'].toDate();
    documentReference = doc.reference;
  }
}