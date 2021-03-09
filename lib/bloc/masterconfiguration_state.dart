part of 'masterconfiguration_bloc.dart';

@immutable
abstract class MasterconfigurationState {}

class MasterconfigurationInitial extends MasterconfigurationState {}

//Get Guru For Kaprog

class OnGetGuruForKaprogLoading extends MasterconfigurationState {}

class OnGetGuruForKaprogSucceded extends MasterconfigurationState {
  List<QueryDocumentSnapshot> result;
  OnGetGuruForKaprogSucceded(this.result);
}

class OnGetGuruForKaprogError extends MasterconfigurationState {
  String message;
  OnGetGuruForKaprogError(this.message);
}

//Add Jurusan

class OnAddJurusanLoading extends MasterconfigurationState {}

class OnAddJurusanSucceded extends MasterconfigurationState {}

class OnAddJurusanError extends MasterconfigurationState {
  String errorMessage;
  OnAddJurusanError(this.errorMessage);
}

//Get All Jurusan

class OnGetJurusanLoading extends MasterconfigurationState {}

class OnGetJurusanSucceded extends MasterconfigurationState {
  QuerySnapshot result;
  OnGetJurusanSucceded(this.result);
}

class OnGetJurusanError extends MasterconfigurationState {
  String messageError;
  OnGetJurusanError(this.messageError);
}

//AddKelas

class OnAddKelasSucceded extends MasterconfigurationState {
  List<String> result;
  OnAddKelasSucceded(this.result);
}

class OnAddKelasError extends MasterconfigurationState {
  String errorMessage;
  OnAddKelasError(this.errorMessage);
}

//Get Kelas For Wali Kelas

class OnGetKelasForWaliKelasSucceded extends MasterconfigurationState {
  Map<String, QuerySnapshot> mapQuerySnapshot;
  OnGetKelasForWaliKelasSucceded(this.mapQuerySnapshot);
}

class OnGetKelasForWaliKelasError extends MasterconfigurationState {
  String errorMessage;
  OnGetKelasForWaliKelasError(this.errorMessage);
}

//Set Wali Kelas

class OnSetWaliKelasSucceded extends MasterconfigurationState {}

class OnSetWaliKelasError extends MasterconfigurationState {
  String errorMessage;
  OnSetWaliKelasError(this.errorMessage);
}

//Add Mata Pelajaran
class OnAddMataPelajaranSucceded extends MasterconfigurationState {}

class OnAddMataPelajaranError extends MasterconfigurationState {
  String errorMessage;
  OnAddMataPelajaranError(this.errorMessage);
}
