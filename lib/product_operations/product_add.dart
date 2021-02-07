import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:avocado/product_operations/product_update.dart';

class UrunEkle extends StatefulWidget {
  @override
  UrunEkleState createState() => UrunEkleState();
}

class UrunEkleState extends State<UrunEkle> {
  TextEditingController urunAdi = TextEditingController();
  TextEditingController urunMiktar = TextEditingController();
  TextEditingController urunFiyat = TextEditingController();
  File _image;
  final picker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;

  urunEkle() async {
    String urunURL = await uploadFile(_image);
    FirebaseFirestore.instance.collection("Urunler").doc(urunAdi.text).set({
      'urunAdi': urunAdi.text,
      'urunMiktari': urunMiktar.text,
      'urunFiyat': urunFiyat.text,
      'urunURL': urunURL
    });
  }

  Future<String> uploadFile(File yuklenecekDosya) async {
    _storageReference =
        _firebaseStorage.ref().child('urunler').child('urunAdi');
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Ürün İşlemleri"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.folder),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => UrunGuncelle()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.lightBlue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null ? Text('No image selected.') : Image.file(_image),
              Container(
                width: 350,
                child: TextField(
                  controller: urunAdi,
                  style: TextStyle(color: Colors.blue),
                  cursorColor: Color(0xFF9b9b9b),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(),
                      ),
                      hintText: "Ürünün Adını Giriniz",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: TextField(
                  cursorWidth: 10,
                  controller: urunFiyat,
                  style: TextStyle(color: Colors.blue),
                  cursorColor: Color(0xFF9b9b9b),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(),
                    ),
                    hintText: "Ürün Fiyatını Giriniz",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: urunMiktar,
                  style: TextStyle(color: Colors.blue),
                  cursorColor: Color(0xFF9b9b9b),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(),
                    ),
                    hintText: "Ürünün Miktarını Giriniz",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 210,
                height: 40,
                child: FlatButton(
                    color: Colors.purple,
                    child: Text("Resim Yükle"),
                    textColor: Colors.white,
                    onPressed: getImage),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 210,
                height: 40,
                child: FlatButton(
                  color: Colors.green,
                  child: Text("Ürünü Ekle"),
                  textColor: Colors.white,
                  onPressed: urunEkle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
