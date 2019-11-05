import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseStore {
  Future uploadFile(String collection, String uid, File avatarImageFile);
}

class Store implements BaseStore {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future uploadFile(String collection, String uid, File avatarImageFile) async {
    StorageReference reference = storage.ref().child(collection);
    StorageUploadTask uploadTask = reference.child(uid).putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          String photoUrl = downloadUrl;
          Firestore.instance
              .collection(collection)
              .document(uid)
              .updateData({'imageUrl': photoUrl});
        });
      }
    });
  }
}
