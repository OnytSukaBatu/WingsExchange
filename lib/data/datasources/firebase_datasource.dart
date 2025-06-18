import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRemoteDataSource {
  // final http.Client client;
  // FirebaseRemoteDataSource(this.client);

  Future<void> updateUserData({
    required String uid,
    required Map<String, String> data,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('main-user').doc(uid).update(data);
  }
}
