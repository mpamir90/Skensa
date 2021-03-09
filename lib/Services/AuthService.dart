import 'package:firebase_auth/firebase_auth.dart';

import 'package:skensa/Services/FireStoreService.dart';

class AuthService {
  static FirebaseAuth myAuth = FirebaseAuth.instance;
  static Stream<User> get userNotify => myAuth.authStateChanges();

  Future<User> signUpWithAccountSkensa(
      String namaLengkap,
      String namaPengguna,
      String email,
      String password,
      Map<String, dynamic> jurusan,
      Map<String, dynamic> kelas,
      String absen,
      String noHp) async {
    UserCredential userCredential = await myAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    await FirestoreService().addSiswa(user.uid, namaLengkap, namaPengguna,
        email, password, jurusan, kelas, absen, noHp);
    await user.sendEmailVerification();
    await user.updateProfile(displayName: namaPengguna);
    return user;
  }

  Future<Map<String, dynamic>> signInWithAccountSkensa(
      String email, String password) async {
    UserCredential userCredential = await myAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    Map<String, dynamic> result = await FirestoreService().isSiswa(user.uid);
    if (user.emailVerified) {
      if (!(result["Email Verified"] as bool)) {
        await FirestoreService().changeEmailVerified(user.uid);
      }
      return result;
    } else {
      AuthService().signOut();
      return result;
    }
  }

  Future<Map<String, dynamic>> signInGuruWithAccountSkensa(
      String email, String password) async {
    UserCredential userCredential = await myAuth.signInWithEmailAndPassword(
        email: email, password: password);
    Map<String, dynamic> result =
        await FirestoreService().isGuru(userCredential.user.uid);
    if (userCredential.user.emailVerified) {
      if (result["Email Verified"] == false) {
        await FirestoreService()
            .changeEmailVerifiedGuru(userCredential.user.uid);
      }

      return result;
    } else {
      AuthService().signOut();
      return result;
    }
  }

  Future<User> signUpGuruWithAccountSkensa(String namaLengkap,
      String namaPengguna, String email, String password, String noHp) async {
    UserCredential userCredential = await myAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    await user.sendEmailVerification();
    FirestoreService()
        .addGuru(user.uid, namaLengkap, namaPengguna, email, password, noHp);
    return user;
  }

  Future<void> signOut() async {
    await myAuth.signOut();
  }
}
