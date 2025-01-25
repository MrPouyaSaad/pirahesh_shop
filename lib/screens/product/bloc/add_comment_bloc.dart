// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pirahesh_shop/data/repo/comment_repository.dart';

part 'add_comment_event.dart';
part 'add_comment_state.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  final ICommentRepository commentRepository;
  AddCommentBloc(
    this.commentRepository,
  ) : super(AddCommentInitial()) {
    on<AddCommentEvent>((event, emit) async {
      if (event is AddCommentButtonClicked) {
        try {
          emit(AddCommentLoading());
          await commentRepository.addComment(
              content: event.content, productId: event.productId);
          emit(AddCommentSuccess());
        } catch (e) {
          emit(AddCommentError());
        }
      }
    });
  }
}
