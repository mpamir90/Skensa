part of 'buatkuis_bloc.dart';

@immutable
abstract class BuatkuisState {}

class BuatkuisInitial extends BuatkuisState {}

class OnChoisedJawabanComplete extends BuatkuisState {}

class OnCreateKuisLoading extends BuatkuisState {}

class OnCreateKuisSucceded extends BuatkuisState {}

class OnCreateKuisError extends BuatkuisState {
  String errorMassage;
  OnCreateKuisError(this.errorMassage);
}
