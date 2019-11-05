import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:islington_navigation_flutter/model/app/users.dart';
import 'package:islington_navigation_flutter/view/credentials/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  PersonData person = PersonData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _storeUserId(String userid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userid", userid);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  Future<FirebaseUser> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print("after google auth");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print("after credentials");

    FirebaseUser userDetails =
        (await _auth.signInWithCredential(credential)).user;

    print("Display Name" + userDetails.displayName);

    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);
    List<ProviderDetails> providerData = new List<ProviderDetails>();

    UserDetails details = UserDetails(
        userDetails.providerId,
        userDetails.displayName,
        userDetails.photoUrl,
        userDetails.email,
        providerData);
    try {
      Users user = new Users(email: userDetails.email);
      try {
        checkEmail(http.Client(), userDetails.email).then((users) async {
          if (users != []) {
            _storeUserId(users.first.user_id);
            Navigator.of(context).pushReplacementNamed('/mainpage');
          } else {
            try {
              Users newUser = new Users(
                  user_id: person.userid,
                  first_login: 0,
                  admin: 0,
                  name: userDetails.displayName,
                  email: userDetails.email,
                  user_name: userDetails.displayName,
                  image: userDetails.photoUrl,
                  provider: "Google");

              createGoogleUser(http.Client(), newUser).then((returnCode) async {
                if (returnCode == "200") {
                  print("Google user registered successfully");
                  _storeUserId(person.userid);
                  Navigator.of(context).pushReplacementNamed('/mainpage');
                } else if (returnCode == "500") {
                  print("Google User failed to register");
                  showInSnackBar("Please try again later");
                }
              }).catchError((onError) {
                print("Could not create data because: " + onError.toString());
              });
            } on PlatformException {
              print("Try again later");
            }
          }
          // else if(returnCode ==)
        }).catchError((onError) {
          print("Could not create data because: " + onError.toString());
        });
      } on PlatformException {
        print("Try again later");
      }
    } on PlatformException {
      print("Try again later");
    }

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    var assetImageGoogle = new AssetImage(
      "assets/google.png",
    );
    var googleImage = new Image(
        image: assetImageGoogle,
        height: 25.0,
        width: MediaQuery.of(context).size.width * 0.10);

    final googleSignin = Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(width: 3.0, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.80,
          child: MaterialButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                googleImage,
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Login using Google",
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            onPressed: () {
              _signInWithGoogle(context);
            },
          ),
        ));

    final emailSignIn = Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(width: 3.0, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.80,
          child: MaterialButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.email,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  "Login using Email",
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                return new LoginPage();
              }));
            },
          ),
        ));

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              googleSignin,
              emailSignIn,
            ],
          ),
        ),
      ),
    );
  }
}

class PersonData {
  String userid = '';
  String username = '';
  String password = '';
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
