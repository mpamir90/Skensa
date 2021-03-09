import 'package:hive/hive.dart';
part 'KelasModel.g.dart';

@HiveType(typeId: 2)
class KelasModel {
  @HiveField(0)
  final String jurusan;
  @HiveField(1)
  final String ketuaKelas;
  @HiveField(2)
  final Map<String, dynamic> mataPelajaran;
  @HiveField(3)
  final String namaKelas;
  @HiveField(4)
  final Map<String, dynamic> waliKelas;
  KelasModel(this.jurusan, this.ketuaKelas, this.mataPelajaran, this.namaKelas,
      this.waliKelas);
}
