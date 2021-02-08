import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:avocado/product_operations/product_update.dart';

class ProductAdd extends StatefulWidget {
  @override
  ProductAddState createState() => ProductAddState();
}

class ProductAddState extends State<ProductAdd> {
  TextEditingController name = TextEditingController();
  TextEditingController kilo = TextEditingController();
  TextEditingController price = TextEditingController();
  File _image;
  final picker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;

  ProductAdd() async {
    String image = await uploadFile(_image);
    FirebaseFirestore.instance.collection("Products").doc(name.text).set({
      'name': name.text,
      'kilo': kilo.text,
      'price': price.text,
      'image': image
    });
  }

  Future<String> uploadFile(File uploadingFile) async {
    _storageReference = _firebaseStorage.ref().child('products').child('name');
    var uploadTask = _storageReference.putFile(uploadingFile);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ürün İşlemleri"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.folder),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProductUpdate()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.green[100],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null ? Text('No image selected.') : Image.file(_image),
              Container(
                width: 350,
                child: TextField(
                  controller: name,
                  style: TextStyle(color: Colors.green[900]),
                  cursorColor: Color(0xFF9b9b9b),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(),
                      ),
                      hintText: "Ürünün Adını Giriniz",
                      hintStyle: TextStyle(
                        color: Colors.green[700],
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
                  controller: price,
                  style: TextStyle(color: Colors.green[900]),
                  cursorColor: Color(0xFF9b9b9b),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(),
                    ),
                    hintText: "Ürün Fiyatını Giriniz",
                    hintStyle: TextStyle(
                      color: Colors.green[700],
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
                  controller: kilo,
                  style: TextStyle(color: Colors.green[900]),
                  cursorColor: Color(0xFF9b9b9b),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(),
                    ),
                    hintText: "Ürünün Miktarını Giriniz",
                    hintStyle: TextStyle(
                      color: Colors.green[700],
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
                    color: Colors.green[400],
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
                  color: Colors.green[400],
                  child: Text("Ürünü Ekle"),
                  textColor: Colors.white,
                  onPressed: ProductAdd,
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
