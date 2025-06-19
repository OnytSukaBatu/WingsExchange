import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wings/data/models/user_model.dart';

class FirebaseRemoteDataSource {
  final FirebaseFirestore firestore;
  FirebaseRemoteDataSource(this.firestore);

  Future<void> updateUserData({
    required String uid,
    required Map<String, String> data,
  }) async {
    await firestore.collection('main-user').doc(uid).update(data);
  }

  Future<UserModel> getUserData({required String email}) async {
    QuerySnapshot snapshot = await firestore
        .collection('main-user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    Object? object = snapshot.docs.first.data();
    Map<String, dynamic> array = object as Map<String, dynamic>;
    array['id'] = snapshot.docs.first.id;
    return UserModel.fromArray(array);
  }
}
