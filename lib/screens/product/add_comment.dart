import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:pirahesh_shop/data/model/product.dart';
import 'package:pirahesh_shop/data/repo/comment_repository.dart';
import 'package:pirahesh_shop/screens/widgets/image.dart';

import '../../data/common/constants.dart';
import '../widgets/text_field.dart';
import 'bloc/add_comment_bloc.dart';

class AddCommentScreen extends StatefulWidget {
  const AddCommentScreen({super.key, required this.product});
  final ProductEntity product;
  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  int recommendButtonValue = -1;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: themeData.colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          title: const Text('Add Comment'),
        ),
        body: BlocProvider(
          create: (context) {
            final bloc = AddCommentBloc(commentRepository);
            bloc.stream.listen((state) {
              if (state is AddCommentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Comment Added Successfuly!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.greenAccent.shade700,
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
                Navigator.pop(context);
              }
            });
            return bloc;
          },
          child: BlocBuilder<AddCommentBloc, AddCommentState>(
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(Constants.primaryPadding / 2),
                        margin: const EdgeInsets.all(Constants.primaryPadding),
                        decoration: BoxDecoration(
                          color: themeData.colorScheme.surface,
                          borderRadius: Constants.primaryRadius,
                          boxShadow: Constants.primaryBoxShadow(context),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: ImageLoadingService(
                                  imageUrl: Constants.baseImageUrl +
                                      widget.product.imageUrl),
                            ),
                            const SizedBox(width: Constants.primaryPadding / 2),
                            Text(widget.product.title),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Description is required!';
                                }
                                if (value.length < 10) {
                                  return 'Description must be at least 10 characters!';
                                }
                                return null;
                              },
                              controller: _descriptionController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: InputDecoration(
                                labelText: 'Description',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                hintText: 'Enter a detailed description...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[300]!, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                              ),
                              minLines: 4,
                              maxLines: 10,
                            )
                          ],
                        ).marginSymmetric(horizontal: Constants.primaryPadding),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AddCommentBloc>(context).add(
                                  AddCommentButtonClicked(
                                    productId: widget.product.id,
                                    content: _descriptionController.text,
                                  ),
                                );
                              }
                            },
                            child: state is AddCommentLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                    'Add',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                      ).marginAll(16),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
