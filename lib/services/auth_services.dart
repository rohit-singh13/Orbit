import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;
  Stream<User?> get authState => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password
  }) async {
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e.code));
    } catch (e) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password
  }) async {
    try{
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    }
    on FirebaseAuthException catch(e) {
      throw Exception(_mapError(e.code));
    } catch (e) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<void> signOut() async{
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  Future<void> emailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e.code));
    } catch (e) {
      throw Exception('Google Sign-In failed');
    }
  }

  String _mapError(String code) => switch (code) {
    'email-already-in-use' => 'Email is already registered',
    'weak-password' => 'Password is too weak',
    'user-not-found' => 'No account found with this email',
    'wrong-password' => 'Incorrect password',
    'invalid-email' => 'Invalid email address',
    'user-disabled' => 'This account has been disabled',
    'too-many-requests' => 'Too many attempts. Try again later',
    'network-request-failed' => 'No internet connection',
    'invalid-credential' => 'Invalid email or password',
    _ => 'Authentication failed',
  };

}