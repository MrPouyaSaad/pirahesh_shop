import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pirahesh_shop/screens/widgets/empty_view.dart';

import '../../../data/repo/comment_repository.dart';
import '../../widgets/error.dart';
import 'bloc/commentlistbloc_bloc.dart';
import 'comment.dart';

class CommentList extends StatelessWidget {
  final int productId;

  const CommentList({super.key, required this.productId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
            repository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListSuccess) {
          if (state.comments.isEmpty) {
            return SliverToBoxAdapter(
              child: EmptyView(
                message: 'No Comment!',
                image:
                    SvgPicture.asset('assets/images/no_data.svg', width: 100),
              ).marginOnly(bottom: 32),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CommentItem(
                    comment: state.comments[index],
                  );
                },
                childCount: state.comments.length,
              ),
            );
          }
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
              exception: state.exception,
              onPressed: () {
                BlocProvider.of<CommentListBloc>(context)
                    .add(CommentListStarted());
              },
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      }),
    );
  }
}
