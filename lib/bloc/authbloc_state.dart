part of 'authbloc_bloc.dart';

@immutable
abstract class AuthblocState {}

class AuthblocInitial extends AuthblocState {}

class OnSignUpGuruLoading extends AuthblocState {}

class OnSignUpGuruSucceded extends AuthblocState {
  User user;
  OnSignUpGuruSucceded(this.user);
}

class OnSignUpGuruError extends AuthblocState {
  String message;

  OnSignUpGuruError(this.message);
}

class OnSignInGuruLoading extends AuthblocState {}

class OnSignInGuruSucceded extends AuthblocState {
  Map<String, dynamic> result;
  OnSignInGuruSucceded(this.result);
}

class OnSignInGuruError extends AuthblocState {
  String message;
  OnSignInGuruError(this.message);
}

class OnGetConfigPendaftaranLoading extends AuthblocState {}

class OnGetConfigPendaftaranSucceded extends AuthblocState {
  DocumentSnapshot result;
  OnGetConfigPendaftaranSucceded(this.result);
}

class OnGetConfigPendaftaranError extends AuthblocState {
  String errorMessage;
  OnGetConfigPendaftaranError(this.errorMessage);
}

class OnGetConfigPendaftaranSiswaLoading extends AuthblocState {}

class OnGetConfigPendaftaranSiswaSucceded extends AuthblocState {
  DocumentSnapshot resultPermission;
  Map<String, QuerySnapshot> jurusanAndKelas;
  OnGetConfigPendaftaranSiswaSucceded(
      this.resultPermission, this.jurusanAndKelas);
}

class OnGetConfigPendaftaranSiswaError extends AuthblocState {
  String errorMessage;
  OnGetConfigPendaftaranSiswaError(this.errorMessage);
}

class OnAddSiswaLoading extends AuthblocState {}

class OnAddSiswaSucceded extends AuthblocState {
  User user;
  OnAddSiswaSucceded(this.user);
}

class OnAddSiswaError extends AuthblocState {
  String errorMessage;
  OnAddSiswaError(this.errorMessage);
}

class OnSignInLoading extends AuthblocState {}

class OnSignInSucceded extends AuthblocState {
  Map<String, dynamic> result;
  OnSignInSucceded(this.result);
}

class OnSignInError extends AuthblocState {
  String errorMessage;
  OnSignInError(this.errorMessage);
}
