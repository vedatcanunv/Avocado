import 'package:avocado/messenger_login/messenger_screen.dart';
import 'package:avocado/order_processing/order_processing.dart';
import 'package:avocado/product_operations/product_add.dart';
import 'package:flutter/material.dart';

class DirectorScreen extends StatefulWidget {
  @override
  _DirectorScreenState createState() => _DirectorScreenState();
}

class _DirectorScreenState extends State<DirectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Yönetici ekranına hoşgeldiniz"),
          backgroundColor: Colors.green,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/director_background.png'),
                  fit: BoxFit.fill)),
          child: Form(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 210,
                  height: 40,
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProductAdd()));
                      },
                      child: Text("Ürün İşlemleri"),
                      textColor: Colors.green[900],
                      color: Colors.green[200]),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 210,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MessengerScreen()));
                    },
                    child: Text("Kurye İşlemleri"),
                    textColor: Colors.green[900],
                    color: Colors.green[200],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 210,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => OrderProcessing()));
                    },
                    child: Text("Siparişleri Görüntüle"),
                    textColor: Colors.green[900],
                    color: Colors.green[200],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
