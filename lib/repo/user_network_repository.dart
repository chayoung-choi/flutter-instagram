import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/constants/firestore_keys.dart';
import 'package:instagram/models/firestore/user_model.dart';

class UserNetworkRepository {
  Future<void> sendData() {
    return Firestore.instance
        .collection('User')
        .document('123123123')
        .setData({'email': 'test@mail.com', 'username': 'myUserName'});
  }

  void getData() {
    Firestore.instance
        .collection('Users')
        .document('123123123')
        .get()
        .then((docSnapshot) => print(docSnapshot.data));
  }
}


UserNetworkRepository userNetworkRepository = UserNetworkRepository();