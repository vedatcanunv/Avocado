import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:avocado/messenger_operations/messenger_location.dart';
import 'dart:io';
import '../messenger_operations/messenger_update.dart';

class MessengerOperations extends StatefulWidget {
  @override
  MessengerOperationsState createState() => MessengerOperationsState();
}

class MessengerOperationsState extends State<MessengerOperations> {
  TextEditingController kuryeAdSoyadi = TextEditingController();
  TextEditingController kuryeTelNo = TextEditingController();
  File _image;
  final picker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;
  String secilenTarih1;

  urunEkle() async {
    String kuryeURL = await uploadFile(_image);
    FirebaseFirestore.instance
        .collection("Kuryeler")
        .doc(kuryeAdSoyadi.text)
        .set({
      'adSoyad': kuryeAdSoyadi.text,
      'girisTarih': secilenTarih1,
      'kuryeFotograf': kuryeURL,
      'kuryeTelNo': kuryeTelNo.text,
    });
  }

  Future<String> uploadFile(File yuklenecekDosya) async {
    _storageReference =
        _firebaseStorage.ref().child('Kuryeler').child('adSoyad');
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }

  Future<DateTime> tarihSec(BuildContext context) {
    return showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2023),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime secilenTarih = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Kurye Ekleme Ekranına Hoşgeldiniz"),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<Widget>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Widget>>[
              PopupMenuItem<Widget>(
                child: InkWell(
                  child: Text('Düzenle'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => KuryeGuncelle()));
                  },
                ),
              ),
              PopupMenuItem<Widget>(
                child: InkWell(
                  child: Text('Konum Bilgisi'),
                  onTap: () {
                    /*
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => GeolocatorWidget()));*/
                  },
                ),
              ),
            ],
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/avocado.png'), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null
                      ? Text('No image selected.')
                      : SizedBox(
                    child: Image.file(_image),
                    height: 250,
                    width: 400,
                  ),
                  TextField(
                    controller: kuryeAdSoyadi,
                    style: TextStyle(color: Colors.blue),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Kuryenin Adı ve Soyadı",
                        hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: kuryeTelNo,
                    style: TextStyle(color: Colors.blue),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mobile_friendly),
                      hintText: "Kuryenin Telefon Numarası",
                      hintStyle: TextStyle(
                        color: Color(0xFF9b9b9b),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    minWidth: 250,
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text("İşe Giriş Tarihini Seç"),
                    onPressed: () async {
                      secilenTarih = await tarihSec(context);
                      if (secilenTarih != null) {
                        var format = DateFormat.yMd('tr');
                        var tarih = format.format(secilenTarih);
                        secilenTarih1 = tarih.toString();
                        setState(() {});
                      } else {
                        print("Lütfen Bir Tarih Seçiniz");
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                      minWidth: 250,
                      color: Colors.blue,
                      child: Text("Kurye Fotoğrafı Yükle"),
                      textColor: Colors.white,
                      onPressed: getImage),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    minWidth: 250,
                    color: Colors.green,
                    child: Text("Kuryeyi Ekle"),
                    textColor: Colors.white,
                    onPressed: urunEkle,
                  ),
                ],
              ),
            ),
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
