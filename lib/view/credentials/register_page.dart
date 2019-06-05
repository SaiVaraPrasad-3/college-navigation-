import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:islington_navigation_flutter/model/app/users.dart';
import 'package:islington_navigation_flutter/view/credentials/login_page.dart';
import 'package:random_string/random_string.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class PersonData {
  String id = '';
  String name = '';
  String phoneNumber = '';
  String email = '';
  String gender = '';
  String user_name = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        icon: Icon(Icons.lock_outline),
        suffixIcon: GestureDetector(
          // dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
    );
  }
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  bool _obscureText = true;
  int _radioValue = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

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
      showInSnackBar('User successfully registered');
      randomAlphaNumeric();

      try {
        Users newUser = new Users(
            user_id: person.id,
            first_login: 0,
            admin: 0,
            name: person.name,
            gender: person.gender,
            email: person.email,
            phone: person.phoneNumber,
            user_name: person.user_name,
            password: person.password);

        createUser(http.Client(), newUser).then((returnCode) async {
          if (returnCode == "200") {
            print("User registered succcessfully");
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (returnCode == "500") {
            print("User failed to register");
            showInSnackBar("Please try again later");
          }
        }).catchError((onError) {
          print("Could not create data because: " + onError.toString());
        });
      } on PlatformException {
        print("Try again later");
      }
    }
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          person.gender = "Male";
          break;
        case 1:
          person.gender = "Female";
          break;
        case 2:
          person.gender = "Others";
          break;
      }
    });
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateEmail(String value) {
    _formWasEdited = true;
    List<Users> newList;
    // checkEmail(http.Client(), value).then((onValue) {
    //   setState(() {
    //     newList = onValue;
    //   });
    // });
    if (value.isEmpty) return 'Email is required.';
    // if (newList.first.name != null) return 'Email is already used';
    final RegExp emailExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!emailExp.hasMatch(value)) return 'Please enter valid email address';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    if (value.length != 10 || !value.startsWith("98"))
      return 'Enter Nepal\'s phone number.';
    return null;
  }

  String _validateUsername(String value) {
    List<Users> newList;
    // checkUsername(http.Client(), value).then((onvalue) {
    //   setState(() {
    //     newList = onvalue;
    //   });
    // });
    _formWasEdited = true;
    // if (newList.first.name != null) return 'Username already taken.';
    if (value.length < 8 || value == null || value.isEmpty)
      return 'Username must be atleast 8 digit long and unique';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value.length < 6)
      return 'Password must be atleast 6 digit long';
    if (passwordField.value != value) return 'The passwords don\'t match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Register'),
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
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.email),
                    hintText: 'E-mail',
                    labelText: 'E-mail *',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onSaved: (String value) {
                    person.email = value;
                  },
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Text(
                  'Gender :',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Male',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Female',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    new Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Others',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                TextFormField(
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
                TextFormField(
                  key: _passwordFieldKey,
                  obscureText: _obscureText,
                  validator: _validatePassword,

                  // onFieldSubmitted: widget.onFieldSubmitted,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Password',
                    labelText: 'Password *',
                    icon: Icon(Icons.lock_outline),
                    suffixIcon: GestureDetector(
                      // dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        semanticLabel:
                            _obscureText ? 'show password' : 'hide password',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Re-type password *',
                      icon: Icon(Icons.lock_open)),
                  obscureText: true,
                  validator: _validatePassword,
                  onSaved: (String value) {
                    person.password = value.trim();
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
