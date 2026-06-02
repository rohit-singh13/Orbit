// import 'package:firebase_auth/firebase_auth.dart';

// class AuthServices {
//   final _auth = FirebaseAuth.instance;
// Stream<User?> get authState => _auth.authStatechanges();
//   User? get currentUser => _auth.currentUser;

  //Email + password sign up
//  Future<UserCredential> signUp(String email, String pwd) async{
// try{
//       return await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
//     }
//     on FirebaseAuthException catch (e) {
//     throw _mapError(e.code);
//    }
//   }
// }