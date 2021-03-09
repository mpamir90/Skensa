part of 'tugasguru_bloc.dart';

@immutable
abstract class TugasguruState {}

class TugasguruInitial extends TugasguruState {}

class OnGetTugasLoading extends TugasguruState {}

class OnGetTugasError extends TugasguruState {
  String errorMessage;
  OnGetTugasError(this.errorMessage);
}

class OnGetTugasSucceded extends TugasguruState {
  List<Map<String, dynamic>> result;
  OnGetTugasSucceded(this.result);
}
