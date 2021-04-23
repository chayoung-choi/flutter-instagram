import 'package:flutter/material.dart';
import 'package:instagram/models/firebase_auth_state.dart';
import 'package:instagram/repo/user_network_repository.dart';
import 'package:instagram/screens/auth_screen.dart';
import 'package:instagram/widget/my_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'constants/material_white.dart';
import 'home_page.dart';
import 'models/user_model_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();

    return ChangeNotifierProvider<FirebaseAuthState>.value(
      value: _firebaseAuthState,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<FirebaseAuthState>.value(
              value: _firebaseAuthState),
          ChangeNotifierProvider<UserModelState>(
            create: (_) => UserModelState(),
          ),
        ],
        child: MaterialApp(
          home: Consumer<FirebaseAuthState>(
            builder: (BuildContext context, FirebaseAuthState firebaseAuthState,
                Widget child) {
              switch (firebaseAuthState.firebaseAuthStatus) {
                case FirebaseAuthStatus.signout:
                  _clearUserModel(context);
                  _currentWidget = AuthScreen();
                  break;
                case FirebaseAuthStatus.signin:
                  _initUserModel(firebaseAuthState, context);
                  _currentWidget = HomePage();
                  break;
                default:
                  _currentWidget = MyProgressIndicator();
              }

              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _currentWidget,
              );
            },
          ),
          theme: ThemeData(primarySwatch: white),
        ),
      ),
    );
  }

  void _initUserModel(
      FirebaseAuthState firebaseAuthState, BuildContext context) {
    UserModelState userModelState =
    Provider.of<UserModelState>(context, listen: false);

    if (userModelState.currentStreamSub == null) {
      userModelState.currentStreamSub = userNetworkRepository
          .getUserModelStream(firebaseAuthState.firebaseUser.uid)
          .listen((userModel) {
        userModelState.userModel = userModel;

        print('userModel: ${userModel.username} , ${userModel.userKey}');
      });
    }
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState =
    Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }
}