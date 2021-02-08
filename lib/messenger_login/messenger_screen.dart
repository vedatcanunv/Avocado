import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avocado/messenger_login/order_screen.dart';

class MessengerScreen extends StatefulWidget {
  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Orders');
  TextEditingController productName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController orderAddress = TextEditingController();
  TextEditingController paymentType = TextEditingController();
  TextEditingController nameSurname = TextEditingController();
  TextEditingController messengerName = TextEditingController();

  orderList() async {
    FirebaseFirestore.instance.collection("Orders").doc(orderAddress.text).set({
      'productName': productName.text,
      'price': price.text,
      'orderAddress': orderAddress.text,
      'paymentType': paymentType.text,
      'nameSurname': nameSurname.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Kurye Ekranına Hoşgeldiniz"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/farm.jpg'), fit: BoxFit.fill)),
        child: Form(
            child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(15, 85, 0, 0),
                child: Text(
                  'Mevcut Siparişleri Görüntülemek İçin Lütfen Butona Basınız.',
                  style: TextStyle(
                      color: Colors.green[400],
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 40,
                      child: FlatButton(
                        color: Colors.green[400],
                        textColor: Colors.white,
                        child: Text(
                          "Sipariş Görüntüle",
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                              //Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderScreen()));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
          ],
        )),
      ),
    );
  }
}
