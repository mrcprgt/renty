// import 'package:firebase/firestore.dart';

// class FirestoreService {
//   final CollectionReference _usersCollectionReference =
//       Firestore.instance.collection("users");

//   Future createUser(User user) async {
//     try {
//       await _usersCollectionReference.document(user.id).setData(user.toJson());
//     } catch (e) {
//       return e.message;
//     }
//   }
// }

// class CollectionReference {}
