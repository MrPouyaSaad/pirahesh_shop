part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileStarted extends ProfileEvent {}

final class ProfileOrderStarted extends ProfileEvent {}

final class ProfileCommentsStarted extends ProfileEvent {}

final class ProfileFavProductsStarted extends ProfileEvent {}
