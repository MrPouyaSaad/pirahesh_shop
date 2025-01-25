part of 'add_comment_bloc.dart';

sealed class AddCommentEvent extends Equatable {
  const AddCommentEvent();

  @override
  List<Object> get props => [];
}

class AddCommentButtonClicked extends AddCommentEvent {
  final int productId;
  final String content;

  AddCommentButtonClicked({required this.productId, required this.content});
}
