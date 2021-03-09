part of 'tugasguru_bloc.dart';

@immutable
abstract class TugasguruEvent {}

class GetTugas extends TugasguruEvent {
  String namaMataPelajaran;
  String idGuru;
  String namaLengkapGuru;
  GetTugas(this.namaMataPelajaran, this.idGuru, this.namaLengkapGuru);
}
