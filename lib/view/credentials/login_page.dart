import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islington_navigation_flutter/view/credentials/register_page.dart';
import 'package:random_string/random_string.dart';
import '../../model/app/users.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class PersonData {
  String userid = '';
  String username = '';
  String password = '';
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();
  bool _obscureText = true;

  bool _autovalidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  _storeUserId(String userid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userid", userid);
  }

  String _validateUsername(String value) {
    _formWasEdited = true;
    if (value == null || value.isEmpty) return 'Please Enter a username.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    if (value == null || value.isEmpty) return 'Please enter a password.';
    return null;
  }

  String randomAlphaNumeric() {
    var alphaLength = randomBetween(0, 10);
    var numericLength = 10 - alphaLength;
    var alpha = randomAlpha(alphaLength);
    var numeric = randomNumeric(numericLength);
    return randomMerge(alpha, numeric);
  }

  /// Merge [a] with [b] and scramble characters.
  String randomMerge(String a, String b) {
    List<int> mergedCodeUnits = new List.from("$a$b".codeUnits);
    mergedCodeUnits.shuffle();
    setState(() {
      person.userid = String.fromCharCodes(mergedCodeUnits);
    });
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors before submitting.');
    } else {
      form.save();
      try {
        Users signinUser =
            new Users(user_name: person.username, password: person.password);
        try {
          loginUser(http.Client(), signinUser).then((users) async {
            if (users != []) {
              print("User logged in succcessfully");
              //get userid from user name

              print("user id is: " + users.first.user_id);
              _storeUserId(users.first.user_id);
              Navigator.of(context).pushReplacementNamed('/backdrop');
            } else {
              print("User failed to login");
              showInSnackBar("Please try again later");
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.supervised_user_circle),
                      hintText: 'Your username',
                      labelText: 'Username',
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (String value) {
                      person.username = value;
                    },
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      hintText: 'Your password',
                      labelText: 'Password',
                      icon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        // dragStartBehavior: DragStartBehavior.down,
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          semanticLabel: _obscureText
                              ? 'show password'
                              : 'hide password',
                        ),
                      ),
                    ),
                    onSaved: (String value) {
                      person.password = value;
                    },
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 24.0),
                  Center(
                    child: RaisedButton(
                      child: const Text('SUBMIT'),
                      onPressed: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const SizedBox(height: 24.0),
                  FlatButton(
                    child: Text(
                      "Not signed up yet?? Sign in here",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (c) {
                        return new RegisterPage();
                      }));
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
