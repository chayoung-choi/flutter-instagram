import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:instagram/utils/simple_snackbar.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progress;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  FacebookLogin _facebookLogin;

  void watchAuthChange() {
    _firebaseAuth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser == null && _firebaseUser == null) {
        changeFirebaseAuthStatus();
        return;
      } else if (firebaseUser != _firebaseUser) {
        _firebaseUser = firebaseUser;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser(BuildContext context,
      {@required String email, @required String password}) {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      String _message = "";
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD':
          _message = "패스워드 보안이 취약합니다.";
          break;
        case 'ERROR_INVALID_EMAIL':
          _message = "이메일 형식이 맞지않습니다.";
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _message = "해당 이메일은 이미 사용중입니다.";
          break;
      }

      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void login(BuildContext context,
      {@required String email, @required String password}) {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      String _message = "";
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          _message = "이메일을 확인해주세요.";
          break;
        case 'ERROR_WRONG_PASSWORD':
          _message = "패스워드가 틀렸습니다.";
          break;
        case 'ERROR_USER_NOT_FOUND':
          _message = "등록되지 않은 유저입니다.";
          break;
        case 'ERROR_USER_DISABLED':
          _message = "접근이 금지된 유저입니다.";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          _message = "잠시 후 다시 시도해주세요.";
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          _message = "접근 제한된 행동입니다.";
          break;
      }

      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void signOut() async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      await _firebaseAuth.signOut();
      if (await _facebookLogin.isLoggedIn) {
        await _facebookLogin.logOut();
      }
    }
    notifyListeners();
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseUser != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }

    notifyListeners();
  }

  void loginWithFacebook(BuildContext context) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    if (_facebookLogin == null) {
      _facebookLogin = FacebookLogin();
    }
    _facebookLogin = FacebookLogin();
    final result = await _facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _handleFacebookTokenWithFirebase(context, result.accessToken.token);

        break;
      case FacebookLoginStatus.cancelledByUser:
        simpleSnackbar(context, 'User cancel facebook sign in');
        break;
      case FacebookLoginStatus.error:
        simpleSnackbar(context, 'facebook sign in error');
        _facebookLogin.logOut();
        break;
    }
  }

  void _handleFacebookTokenWithFirebase(
      BuildContext context, String token) async {
    final AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token);

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    if (user == null) {
      simpleSnackbar(context, 'facebook 로그인에 실패하였습니다. 잠시 후 다시 시도해주세요.');
    } else {
      _firebaseUser = user;
    }
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
}

enum FirebaseAuthStatus { signout, progress, signin }
