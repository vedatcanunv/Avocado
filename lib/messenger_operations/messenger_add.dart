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
  TextEditingController nameSurname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  File _image;
  final picker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;
  String selectedDate1;

  productAdd() async {
    String picture = await uploadFile(_image);
    FirebaseFirestore.instance
        .collection("Messengers")
        .doc(nameSurname.text)
        .set({
      'nameSurname': nameSurname.text,
      'selectedDate': selectedDate1,
      'picture': picture,
      'phoneNumber': phoneNumber.text,
    });
  }

  Future<String> uploadFile(File uploadingFile) async {
    _storageReference =
        _firebaseStorage.ref().child('Messengers').child('nameSurname');
    var uploadTask = _storageReference.putFile(uploadingFile);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }

  Future<DateTime> selectDate(BuildContext context) {
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
    DateTime selectedDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Kurye Ekleme Ekranı"),
        elevation: 0,
        backgroundColor: Colors.green,
        actions: <Widget>[
          PopupMenuButton<Widget>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Widget>>[
              PopupMenuItem<Widget>(
                child: InkWell(
                  child: Text('Düzenle'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MessengerUpdate()));
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
        color: Colors.green[100],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                    controller: nameSurname,
                    style: TextStyle(color: Colors.green),
                    cursorColor: Color(0xFF1B5E20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Kuryenin Adı ve Soyadı",
                        hintStyle: TextStyle(
                          color: Color(0xFF1B5E20),
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: phoneNumber,
                    style: TextStyle(color: Colors.green),
                    cursorColor: Color(0xFF1B5E20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mobile_friendly),
                      hintText: "Kuryenin Telefon Numarası",
                      hintStyle: TextStyle(
                        color: Color(0xFF1B5E20),
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
                    color: Colors.green[400],
                    textColor: Colors.green[900],
                    child: Text("İşe Giriş Tarihini Seç"),
                    onPressed: () async {
                      selectedDate = await selectDate(context);
                      if (selectedDate != null) {
                        var format = DateFormat.yMd('tr');
                        var date = format.format(selectedDate);
                        selectedDate1 = date.toString();
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
                      color: Colors.green[400],
                      child: Text("Kurye Fotoğrafı Yükle"),
                      textColor: Colors.green[900],
                      onPressed: getImage),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    minWidth: 250,
                    color: Colors.green[400],
                    child: Text("Kuryeyi Ekle"),
                    textColor: Colors.green[900],
                    onPressed: productAdd,
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
