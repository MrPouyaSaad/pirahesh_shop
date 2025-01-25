import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pirahesh_shop/data/repo/profile_repository.dart';
import 'package:pirahesh_shop/screens/widgets/empty_view.dart';

import '../product/comment/comment.dart';
import 'bloc/profile_bloc.dart';

class UserComments extends StatelessWidget {
  const UserComments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            ProfileBloc(profileRepository)..add(ProfileCommentsStarted()),
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileCommentsLoading || state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileCommentsSuccess) {
            if (state.comments.isEmpty) {
              return Center(
                child: EmptyView(
                    message: 'No Comments!',
                    image: SvgPicture.asset(
                      'assets/images/no_data.svg',
                      width: 124,
                    )),
              );
            }
            return SafeArea(
              child: ListView.builder(
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  return CommentItem(
                    comment: state.comments[index],
                  );
                },
              ),
            );
          } else if (state is ProfileCommentsError) {
            return Center(child: Text('Error in loading comments'));
          } else {
            throw UnimplementedError();
          }
        }),
      ),
    );
  }
}
