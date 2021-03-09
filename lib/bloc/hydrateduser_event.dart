part of 'hydrateduser_bloc.dart';

@immutable
abstract class HydrateduserEvent {}

class AddInfoGuru extends HydrateduserEvent {
  DocumentSnapshot guru;
  AddInfoGuru(this.guru);
}

class UpdateDataGuru extends HydrateduserEvent {
  String email, password;
  UpdateDataGuru(this.email, this.password);
}

class AddInfoSiswa extends HydrateduserEvent {
  DocumentSnapshot siswa;
  AddInfoSiswa(this.siswa);
}

class SignOut extends HydrateduserEvent {}
