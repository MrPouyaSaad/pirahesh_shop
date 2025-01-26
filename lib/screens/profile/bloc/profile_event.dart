part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileStarted extends ProfileEvent {
  final AuthInfo? authInfo;

  ProfileStarted({required this.authInfo});
}

final class ProfileOrderStarted extends ProfileEvent {}

final class ProfileCommentsStarted extends ProfileEvent {}

final class ProfileFavProductsStarted extends ProfileEvent {}

final class ProfileAuthInfoChanged extends ProfileEvent {
  final AuthInfo? authInfo;

  ProfileAuthInfoChanged({required this.authInfo});
}

final class ProfileSignOutButtonClicked extends ProfileEvent {}
