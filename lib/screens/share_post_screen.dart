import 'dart:io';

import 'package:flutter/material.dart';

class SharePostScreen extends StatelessWidget {
  final File imageFile;
  final String postKey;

  const SharePostScreen(this.imageFile, {Key key, @required this.postKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(imageFile);
  }
}
