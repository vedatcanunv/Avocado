import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
        title: Text("Mevcut Siparişler"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.green[100],
        child: StreamBuilder(
            stream: ref.snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                var orderLength = snapshot.data.docs.length;
                return ListView.builder(
                    itemCount: orderLength,
                    itemBuilder: (context, index) {
                      var orders = snapshot.data.docs[index];
                      return ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.check),
                          color: Colors.greenAccent[700],
                          iconSize: 50,
                          onPressed: () {
                            productName.text = orders['productName'];
                            price.text = orders['price'];
                            orderAddress.text = orders['orderAddress'];
                            nameSurname.text = orders['nameSurname'];
                            paymentType.text = orders['paymentType'];
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        width: 300,
                                        color: Colors.green[400],
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextField(
                                                enabled: false,
                                                controller: productName,
                                                style: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                cursorColor: Color(0xFF1B5E20),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              TextField(
                                                enabled: false,
                                                controller: price,
                                                style: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                cursorColor: Color(0xFF1B5E20),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              TextField(
                                                enabled: false,
                                                controller: nameSurname,
                                                style: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                cursorColor: Color(0xFF1B5E20),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              TextField(
                                                enabled: false,
                                                controller: orderAddress,
                                                style: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                cursorColor: Color(0xFF1B5E20),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              TextField(
                                                enabled: false,
                                                controller: paymentType,
                                                style: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                cursorColor: Color(0xFF1B5E20),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              FlatButton(
                                                  color: Colors.green,
                                                  child: Text("Teslim Alındı"),
                                                  textColor: Colors.green[900],
                                                  onPressed: () {
                                                    orderList();
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                        ),
                        title: Text(
                          "Ürün Adı : " + orders['productName'] + "",
                          style: TextStyle(color: Colors.green[900]),
                        ),
                        subtitle: Form(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Ürün Fiyatı : " + orders['price'] + "",
                                style: TextStyle(color: Colors.green[900]),
                              ),
                              Text(
                                "Siparis Adresi : " +
                                    orders['orderAddress'] +
                                    "",
                                style: TextStyle(color: Colors.green[900]),
                              ),
                              Text(
                                "Kullanıcı Adı : " + orders['nameSurname'] + "",
                                style: TextStyle(color: Colors.green[900]),
                              ),
                              Text(
                                "Ödeme Türü : " + orders['paymentType'] + "",
                                style: TextStyle(color: Colors.green[900]),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      );
                    });
              } else {
                return Text(
                  "Olmuyor",
                  style: TextStyle(color: Colors.green[900]),
                );
              }
            }),
      ),
    );
  }
}
