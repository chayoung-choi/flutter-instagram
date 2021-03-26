import 'package:flutter/material.dart';
import 'package:instagram/constants/common_size.dart';
import 'package:instagram/widget/rounded_avatar.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedAvatar(size: 24),
        SizedBox(
          width: common_xxs_gap,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'cyoung90',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextSpan(text: ' '),
                TextSpan(
                    text: 'I love myself!!!',
                    style: TextStyle(color: Colors.black87)),
              ]),
            ),
            Text(
              'timestamp',
              style: TextStyle(color: Colors.grey[400], fontSize: 10),
            )
          ],
        ),
      ],
    );
  }
}