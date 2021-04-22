import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/repo/user_network_repository.dart';
import 'package:instagram/widget/post.dart';


class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: IconButton(
            onPressed: null,
            icon: Icon(
              CupertinoIcons.photo_camera_solid,
              color: Colors.black87,
            )),
        middle: Text(
          'instagram',
          style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black87),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: (){
                // userNetworkRepository.sendData();
              },
              icon: ImageIcon(
                AssetImage('assets/images/actionbar_camera.png'),
                color: Colors.black87,
              ),
            ),IconButton(
              onPressed: (){
                // userNetworkRepository.getData();
              },
              icon: ImageIcon(
                AssetImage('assets/images/actionbar_camera.png'),
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: feedListBuilder,
        itemCount: 30,
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, int index) {
    return Post(index);
  }
}
