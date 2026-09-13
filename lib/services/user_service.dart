import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(FirebaseFirestore.instance);
});

class UserService {
  final FirebaseFirestore _firestore;

  UserService(this._firestore);

  CollectionReference get _usersCollection => _firestore.collection(AppConstants.usersCollection);

  Future<void> createUserProfile(String uid, String name, String email) async {
    final user = UserModel(
      uid: uid,
      name: name,
      email: email,
      isOnline: true,
    );
    await _usersCollection.doc(uid).set(user.toMap());
  }

  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    await _usersCollection.doc(uid).update({'isOnline': isOnline});
  }

  Future<void> updateProfile({required String uid, required String name, String? avatarUrl}) async {
    final data = <String, dynamic>{'name': name};
    if (avatarUrl != null) {
      data['avatarUrl'] = avatarUrl;
    }
    await _usersCollection.doc(uid).update(data);
  }

  Stream<UserModel?> getUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }

  Stream<List<UserModel>> getContacts(String currentUserId) {
    return _usersCollection
        .where('uid', isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
