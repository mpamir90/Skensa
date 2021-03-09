import 'package:hive/hive.dart';

part 'SoalModel.g.dart';

@HiveType(typeId: 1)
class SoalModel {
  @HiveField(0)
  final String namaTugas;
  @HiveField(1)
  final Map<String, dynamic> guru;
  @HiveField(2)
  final List kelas;
  @HiveField(3)
  final String namaMataPelajaran;
  @HiveField(4)
  final List soal;
  @HiveField(5)
  final String tipe;
  @HiveField(6)
  final String waktuKuis;
  @HiveField(7)
  final String idSoal;

  SoalModel(this.namaTugas, this.guru, this.kelas, this.namaMataPelajaran,
      this.soal, this.tipe, this.waktuKuis, this.idSoal);
}
