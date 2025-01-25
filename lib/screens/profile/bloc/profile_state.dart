part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileLoading extends ProfileState {}

final class ProfilError extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final User user;

  ProfileSuccess({required this.user});
}

final class ProfileOrderLoading extends ProfileState {}

final class ProfilOrderError extends ProfileState {}

final class ProfileOrderSuccess extends ProfileState {
  final List<Order> order;

  ProfileOrderSuccess({required this.order});
}

final class ProfileCommentsLoading extends ProfileState {}

final class ProfileCommentsError extends ProfileState {}

final class ProfileCommentsSuccess extends ProfileState {
  final List<CommentEntity> comments;

  ProfileCommentsSuccess({required this.comments});
}

final class ProfileFavProfuctsLoading extends ProfileState {}

final class ProfileFavProductsError extends ProfileState {}

final class ProfileFavProfuctsSuccess extends ProfileState {
  final List<ProductEntity> products;

  ProfileFavProfuctsSuccess({required this.products});
}
