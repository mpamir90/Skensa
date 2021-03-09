part of 'authbloc_bloc.dart';

@immutable
abstract class AuthblocEvent {}

class SignUpGuru extends AuthblocEvent {
  String namaLengkap, namaPengguna, email, password, noHp;
  BuildContext context;

  SignUpGuru(this.namaLengkap, this.namaPengguna, this.email, this.password,
      this.noHp, this.context);
}

class SignIn extends AuthblocEvent {
  String email, password;
  SignIn(this.email, this.password);
}

class SignInGuru extends AuthblocEvent {
  String email, password;
  BuildContext context;
  SignInGuru(this.email, this.password, this.context);
}

class GetConfigPendaftaran extends AuthblocEvent {}

class GetConfigPendaftaranSiswa extends AuthblocEvent {}

class AddSiswa extends AuthblocEvent {
  String namaLengkap, namaPengguna, email, password, absen, noHp;
  Map<String, dynamic> jurusan, kelas;

  AddSiswa(this.namaLengkap, this.namaPengguna, this.email, this.password,
      this.jurusan, this.kelas, this.absen, this.noHp);
}
