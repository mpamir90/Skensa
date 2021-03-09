part of 'hydrateduser_bloc.dart';

@immutable
abstract class HydrateduserState {}

class HydrateduserInitial extends HydrateduserState {}

class OnAddInfoGuruSucceded extends HydrateduserState {
  Map<String, dynamic> guru;
  OnAddInfoGuruSucceded(this.guru);
}

class OnUpdateDataGuruLoading extends HydrateduserState {}

class OnUpdateDataGuruError extends HydrateduserState {
  String errorMessage;
  OnUpdateDataGuruError(this.errorMessage);
}

class OnAddInfoSiswaSucceded extends HydrateduserState {
  Map<String, dynamic> siswa;
  OnAddInfoSiswaSucceded(this.siswa);
}
