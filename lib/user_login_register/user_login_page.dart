import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:avocado/user_login_register/user_register_page.dart';
import 'package:avocado/director_login/director_login.dart';
import 'package:avocado/messenger_login/messenger_login.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                        child: Text(
                          'Giriş',
                          style: TextStyle(fontSize: 20),
                        ),
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
            context, MaterialPageRoute(builder: (context) => Home(user: user)));
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
