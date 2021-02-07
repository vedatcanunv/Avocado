import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:avocado/user_login_register/user_register_page.dart';
import 'package:avocado/director_login/director_login.dart';
import 'package:avocado/messenger_login/messenger_login.dart';
import 'package:avocado/screens/home_page.dart';
import 'package:avocado/tabs/home_tab.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  // Default Form Loading State
  bool _loginFormLoading = false;

  // Form Input Field Values
  String _loginEmail = "";
  String _loginPassword = "";

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Avocado'),
          backgroundColor: Colors.green,
        ),
        body: Container(
          color: Colors.green[50],
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Kullanıcı Girişi',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                      )),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Lütfen e-mail girişi yapınız' : null,
                      onSaved: (value) => _email = value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) =>
                          value.isEmpty ? 'Lütfen şifre girişi yapınız' : null,
                      onSaved: (value) => _password = value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Şifre',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    textColor: Colors.red[400],
                    child: Text('Şifremi Unuttum'),
                  ),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.green[900],
                        color: Colors.green[200],
                        child: Text("Giriş"),
                        onPressed: () => signIn(),
                      )),
                  Container(
                      child: Row(
                    children: <Widget>[
                      Text('Henüz kaydolmadınız mı?',
                          style: TextStyle(color: Colors.red[400])),
                      FlatButton(
                          textColor: Colors.red[300],
                          child: Text(
                            'Kaydol',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                                //Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserRegister()));
                          })
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 160,
                            height: 60,
                            child: FlatButton(
                              color: Colors.green[200],
                              textColor: Colors.green[900],
                              child: Text(
                                "Yönetici Girişi",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    //Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DirectorLogin()));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 160,
                            height: 60,
                            child: FlatButton(
                              color: Colors.green[200],
                              textColor: Colors.green[900],
                              child: Text(
                                "Kurye Girişi",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    //Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MessengerLogin()));
                              },
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )),
                ],
              )),
        ));
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      //todo login to firebase
      formState.save();
      // Firebase ile iletişim noktası
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
