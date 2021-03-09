part of 'gurumanagement_bloc.dart';

@immutable
abstract class GurumanagementState {}

class GurumanagementInitial extends GurumanagementState {}

class OnGetInfoKelasLoading extends GurumanagementState {}

class OnGetInfoKelasSucceded extends GurumanagementState {
  DocumentSnapshot result;
  QuerySnapshot allPelajaran;
  QuerySnapshot allGuru;
  OnGetInfoKelasSucceded(this.result, this.allPelajaran, this.allGuru);
}

class OnGetInfoKelasError extends GurumanagementState {
  String errorMessage;
  OnGetInfoKelasError(this.errorMessage);
}

class OnAddMataPelajaranKelasLoading extends GurumanagementState {}

class OnAddMataPelajaranKelasSucceded extends GurumanagementState {}

class OnAddMataPelajaranKelasError extends GurumanagementState {
  String errorMessage;
  OnAddMataPelajaranKelasError(this.errorMessage);
}

class OnGetPropertyMengajarGuruLoading extends GurumanagementState {}

class OnGetPropertyMengajarGuruSucceded extends GurumanagementState {
  QuerySnapshot allKelas;
  QuerySnapshot allMataPelajaran;
  OnGetPropertyMengajarGuruSucceded(this.allKelas, this.allMataPelajaran);
}

class OnGetPropertyMengajarGuruError extends GurumanagementState {
  String errorMessage;
  OnGetPropertyMengajarGuruError(this.errorMessage);
}

class OnAddMataPelajaranGuruLoading extends GurumanagementState {}

class OnAddMataPelajaranGuruSucceded extends GurumanagementState {}

class OnAddMataPelajaranGuruError extends GurumanagementState {
  String errorMessage;
  OnAddMataPelajaranGuruError(this.errorMessage);
}
