import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "../screens/login_screen.dart";
import "../screens/main_screen.dart";


class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const MainScreen();
          } else{
            return const LoginScreen();
          }
        },
      )
    );
  }
}










// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'package:flutter/widgets.dart';
// import '../utils/utils.dart';
//
// enum AuthStatus { uninitialized, authenticated, unauthenticated }
//
// class Auth extends ChangeNotifier {
//   Client client = Client();
//   late final Account account;
//
//   late User _currentUser;
//
//   AuthStatus _status = AuthStatus.uninitialized;
//
//   User get currentUser => _currentUser;
//   AuthStatus get status => _status;
//   String? get userName => _currentUser.name;
//   String? get email => _currentUser.email;
//   String? get userId => _currentUser.$id;
//
//   Auth() {
//     init();
//     loadUser();
//   }
//
//   init() {
//     client.setEndpoint(projectURL).setProject(projectID).setSelfSigned();
//     account = Account(client);
//   }
//
//   loadUser() async {
//     try {
//       final user = await account.get();
//       _status = AuthStatus.authenticated;
//       _currentUser = user;
//     } catch (e) {
//       _status = AuthStatus.unauthenticated;
//     } finally {
//       notifyListeners();
//     }
//   }
//
//   Future<Session> signIn(
//       {required String email, required String password}) async {
//     try {
//       final session =
//           await account.createEmailSession(email: email, password: password);
//       _currentUser = await account.get();
//       _status = AuthStatus.authenticated;
//       return session;
//     } finally {
//       notifyListeners();
//     }
//   }
//
//   signOut() async {
//     try {
//       await account.deleteSession(sessionId: 'current');
//       _status = AuthStatus.unauthenticated;
//     } finally {
//       notifyListeners();
//     }
//   }
// }
