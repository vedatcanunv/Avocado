import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'messenger_screen.dart';

class MessengerLogin extends StatefulWidget {
  @override
  _MessengerLoginState createState() => _MessengerLoginState();
}

class _MessengerLoginState extends State<MessengerLogin> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kurye Giriş Ekranı"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.green[50],
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 4.0,
                color: Colors.green[200],
                margin: EdgeInsets.only(left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          validator: (value) => value.isEmpty
                              ? 'Lütfen email girişi yapınız'
                              : null,
                          onSaved: (value) => _email = value,
                          style: TextStyle(color: Color(0xFF000000)),
                          cursorColor: Color(0xFF9b9b9b),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey[600],
                            ),
                            hintText: "e-posta",
                            hintStyle: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) =>
                              value.isEmpty ? 'Lütfen şifre giriniz.' : null,
                          onSaved: (value) => _password = value,
                          style: TextStyle(color: Color(0xFF000000)),
                          cursorColor: Color(0xFF9b9b9b),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.grey[600],
                            ),
                            hintText: "Şifre",
                            hintStyle: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: FlatButton(
                            onPressed: () => signIn(),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                "Giriş",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            color: Colors.green[600],
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessengerScreen()));
      } catch (user) {
        print(user.toString());
      }
    }
  }
}
