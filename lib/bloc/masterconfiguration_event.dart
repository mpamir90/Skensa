part of 'masterconfiguration_bloc.dart';

@immutable
abstract class MasterconfigurationEvent {}

class GetGuruForKaprog extends MasterconfigurationEvent {}

class GetJurusanAll extends MasterconfigurationEvent {}

class GetKelasForWaliKelas extends MasterconfigurationEvent {}

class AddJurusan extends MasterconfigurationEvent {
  String namaJurusan, singkatan, namaLengkapGuru, uidGuru;
  AddJurusan(
      this.namaJurusan, this.singkatan, this.namaLengkapGuru, this.uidGuru);
}

class AddKelas extends MasterconfigurationEvent {
  String jurusanSingkatan;
  String jumlahTingkatan;
  String jumlahKelasPerTingkatan;
  String jurusan;

  AddKelas(this.jurusanSingkatan, this.jumlahTingkatan,
      this.jumlahKelasPerTingkatan, this.jurusan);
}

class SetWaliKelas extends MasterconfigurationEvent {
  String idKelas;
  String namaKelas;
  String namaLengkapGuru;
  String uidGuru;

  SetWaliKelas(
      this.idKelas, this.namaKelas, this.namaLengkapGuru, this.uidGuru);
}

class AddMataPelajaran extends MasterconfigurationEvent {
  String namaMataPelajaran;
  AddMataPelajaran(this.namaMataPelajaran);
}
