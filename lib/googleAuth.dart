import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
 final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 final GoogleSignIn _googleSignIn = GoogleSignIn();

 Future<User?> authenticate() async {
  try {
   // Attempt to get the currently authenticated user
   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

   if (googleUser != null) {
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
     accessToken: googleAuth.accessToken,
     idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Return the user from the credential
    return userCredential.user;
   }
  } catch (e) {
   print('Error signing in with Google:------------------ $e');
  }
  return null;
 }
}
