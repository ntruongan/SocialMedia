import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/pages/activity_feed.dart';
import 'package:flutter_application_1/pages/create_account.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/search.dart';
import 'package:flutter_application_1/pages/timeline.dart';
import 'package:flutter_application_1/pages/upload.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection("users");
final postsRef = Firestore.instance.collection('posts');
final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Sign in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // reauth user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      print('User signed in!: $account');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  opTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  createUserInFirestore() async {
    // 1. check if user exists in users collection in database (based on id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();
    if (!doc.exists) {
      // 2. if the user dosnt exists, then we want ot take them to the create account page
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      // 3. get username from create account, use it to make new users document in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "email": user.email,
        "fullname": user.displayName,
        "timestamp": timestamp,
        "photoUrl": user.photoUrl,
      });

      doc = await usersRef.document(user.id).get();
    }

    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          //Timeline(),
          ElevatedButton(onPressed: logout, child: Text('Logout')),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: opTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera, size: 35.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );

    //return ElevatedButton(onPressed: logout, child: Text('Logout'));
  }

  Scaffold buildUnauthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Theme.of(context).accentColor.withOpacity(0.7),
              Theme.of(context).primaryColorDark
            ])),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'FlutterShare',
              style: TextStyle(
                  fontFamily: "assets\fonts\Signatra.ttf",
                  fontSize: 50.0,
                  color: Colors.white),
            ),
            GestureDetector(
                onTap: login,
                child: Container(
                  width: 260.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  )),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnauthScreen();
  }
}
