import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_image.dart';
import 'package:flutter_application_1/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print(''),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
