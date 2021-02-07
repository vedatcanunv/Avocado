import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserRegisterState();
}

class UserRegisterState extends State<UserRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  // ignore: unused_field
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    UserRegister();
    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanıcı Kayıt Ekranı"),
          backgroundColor: Colors.green[500],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.green[50],
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 180, 20, 10),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Lütfen geçerli bir e-mail giriniz.';
                      }
                      return null;
                    },
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
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Lütfen bir şifre giriniz.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.green[200],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _register();
                      }
                    },
                    textColor: Colors.green[900],
                    child:
                        const Text('Kayıt Ol', style: TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_success == null
                      ? ''
                      : (_success
                          ? 'Kayıt Başarılı ' + _email
                          : 'Kayıt Başarısız')),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _register() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (userCredential != null) {
      setState(() {
        _success = true;
        _email = _emailController.text;
      });
    } else {
      setState(() {
        _success = true;
      });
    }
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
