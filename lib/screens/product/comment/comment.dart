import 'package:flutter/material.dart';
import 'package:pirahesh_shop/data/common/constants.dart';

import '../../../data/model/comment.dart';
import '../../widgets/image.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          boxShadow: Constants.primaryBoxShadow(context),
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.primaryPadding / 2),
            decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              borderRadius: Constants.primaryRadius,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: ImageLoadingService(
                      imageUrl: Constants.baseImageUrl +
                          comment.productEntity.imageUrl),
                ),
                const SizedBox(width: Constants.primaryPadding / 2),
                Text(comment.productEntity.title),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
              Text(comment.createdAt.substring(0, 10),
                  style: themeData.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            comment.content,
            style: const TextStyle(height: 1.4, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
