import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/controller/utils/backdrop.dart';
import 'package:islington_navigation_flutter/model/app/users.dart';
import 'package:islington_navigation_flutter/view/credentials/login_page.dart';
import 'package:random_string/random_string.dart';

class UpdateProfilePage extends StatefulWidget {
  UpdateProfilePage({Key key, @required this.user_id});

  final String user_id;

  @override
  UpdateProfilePageState createState() => UpdateProfilePageState();
}

class PersonData {
  String id = '';
  String name = '';
  String phoneNumber = '';
  String email = '';
  String user_name = '';
}

class UpdateProfilePageState extends State<UpdateProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();
  List<Users> userList;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  int _radioValue = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserWithUID(http.Client(), widget.user_id).then((value) {
      setState(() {
        userList = value;

        person.id = userList.first.user_id;
        nameController.text = userList.first.name;
        phoneController.text = userList.first.phone;
        usernameController.text = userList.first.user_name;
        emailController.text = userList.first.email;
      });
    });
  }

  /// Generates a random string of [length] with alpha-numeric characters.
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
      person.id = String.fromCharCodes(mergedCodeUnits);
    });
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors before submitting.');
    } else {
      form.save();
      showInSnackBar('Updating User!!! Please wait.');

      try {
        Users newUser = new Users(
          user_id: person.id,
          name: person.name,
          user_name: person.user_name,
          phone: person.phoneNumber,
        );

        updateUser(http.Client(), newUser).then((returnCode) async {
          if (returnCode == "200") {
            print("User updated succcessfully");
            showInSnackBar("User updated succcessfully");
            // Navigator.popAndPushNamed(context, '/checkauth');
            Navigator.of(context).pushReplacementNamed('/checkAuth');
          } else if (returnCode == "500") {
            print("User failed to register");
            showInSnackBar("Please try again later");
          }
        }).catchError((onError) {
          print("Could not create data because: " + onError.toString());
        }).whenComplete(() {
          print("User updated succcessfully 2");
          showInSnackBar("User updated succcessfully");
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              settings: const RouteSettings(name: '/backdrop'),
              builder: (context) => new BackDropPage(pageName: 'profile')));
          // Navigator.of(context).pushReplacementNamed('/checkAuth');
        });
      } on PlatformException {
        print("Try again later");
      }
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    if (value.length != 10 || !value.startsWith("98"))
      return 'Enter Nepal\'s phone number.';
    return null;
  }

  String _validateUsername(String value) {
    // List<Users> newList;
    _formWasEdited = true;
    // checkUsername(http.Client(), value).then((onvalue) {
    //   setState(() {
    //     print("inside check user name");
    //     newList = onvalue;
    //   });
    // });
    // if (newList.first.name != null) return 'Username already taken';
    if (value.length < 8 || value == null || value.isEmpty)
      return 'Username must be atleast 8 digit long and unique';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: SingleChildScrollView(
            // dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: emailController,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.email),
                    hintText: 'E-mail',
                    labelText: 'E-mail *',
                  ),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Full Name',
                    labelText: 'Full Name *',
                  ),
                  onSaved: (String value) {
                    person.name = value;
                  },
                  validator: _validateName,
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.phone),
                    hintText: 'Phone Number',
                    labelText: 'Phone Number *',
                    prefixText: '+977',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (String value) {
                    person.phoneNumber = value;
                  },
                  validator: _validatePhoneNumber,
                  // TextInputFormatters for keyboard type.
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                    // Fit the validating format.
                  ],
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.supervised_user_circle),
                    hintText: 'Username',
                    labelText: 'Username *',
                  ),
                  validator: _validateUsername,
                  keyboardType: TextInputType.text,
                  onSaved: (String value) {
                    person.user_name = value;
                  },
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: RaisedButton(
                    child: const Text('SUBMIT'),
                    onPressed: _handleSubmitted,
                  ),
                ),
                const SizedBox(height: 24.0),
                Text('* indicates required field',
                    style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
