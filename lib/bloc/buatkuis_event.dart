part of 'buatkuis_bloc.dart';

@immutable
abstract class BuatkuisEvent {}

class ChoisedJawaban extends BuatkuisEvent {}

class CreateKuis extends BuatkuisEvent {
  String namaTugas;
  String namaMataPelajaran;
  Map<String, dynamic> guru;
  List<Map<String, dynamic>> kelas;
  List<Map<String, dynamic>> soal;
  String waktuKuis;
  CreateKuis(this.namaTugas, this.namaMataPelajaran, this.guru, this.kelas,
      this.soal, this.waktuKuis);
}
