part of 'gurumanagement_bloc.dart';

@immutable
abstract class GurumanagementEvent {}

class GetInfoKelas extends GurumanagementEvent {
  String idKelas;
  GetInfoKelas(this.idKelas);
}

class AddMataPelajaranKelas extends GurumanagementEvent {
  String namaKelas;
  String idKelas;
  List listMataPelajaran;
  AddMataPelajaranKelas(this.namaKelas, this.idKelas, this.listMataPelajaran);
}

class GetPropertyMengajarGuru extends GurumanagementEvent {}

class AddInitialState extends GurumanagementEvent {}

class AddMataPelajaranGuru extends GurumanagementEvent {
  String idGuru;
  String mataPelajaran;
  String namaGuru;
  List<Map<String, dynamic>> listKelas;
  AddMataPelajaranGuru(
      this.idGuru, this.namaGuru, this.mataPelajaran, this.listKelas);
}
