import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessengerUpdate extends StatefulWidget {
  @override
  _MessengerUpdateState createState() => _MessengerUpdateState();
}

class _MessengerUpdateState extends State<MessengerUpdate> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Messengers');
  TextEditingController nameSurname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String selectedDate1;
  File _image;
  final picker = ImagePicker();

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

  BuildContext context2() => context;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;

  Future<String> uploadFile(File uploadingFile) async {
    _storageReference =
        _firebaseStorage.ref().child('Messengers').child('nameSurname');
    var uploadTask = _storageReference.putFile(uploadingFile);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  void productUpdate(snapshot, index) async {
    String picture = await uploadFile(_image);
    snapshot.data.docs[index].reference.update({
      'nameSurname': nameSurname.text,
      'selectedDate': selectedDate1,
      'picture': picture,
      'phoneNumber': phoneNumber.text,
    }).whenComplete(() => Navigator.pop(context));
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.blue,
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var messengerLenght = snapshot.data.docs.length;
              return ListView.builder(
                  itemCount: messengerLenght,
                  itemBuilder: (context, index) {
                    var messengers = snapshot.data.docs[index];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.black,
                        onPressed: () {
                          nameSurname.text = messengers['nameSurname'];
                          selectedDate1 = messengers['selectedDate'];
                          phoneNumber.text = messengers['phoneNumber'];
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            _image == null
                                                ? Text('No image selected.')
                                                : Image.file(_image),
                                            TextFormField(
                                              controller: nameSurname,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              cursorColor: Color(0xFF9b9b9b),
                                              decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.person),
                                                  hintText:
                                                      "Kuryenin Adı ve Soyadı",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFF9b9b9b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                              controller: phoneNumber,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              cursorColor: Color(0xFF9b9b9b),
                                              decoration: InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.mobile_friendly),
                                                hintText:
                                                    "Kuryenin Telefon Numarası",
                                                hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                              color: Colors.blue,
                                              textColor: Colors.white,
                                              child: Text(
                                                  "İşe Giriş Tarihini Seç"),
                                              onPressed: () async {
                                                selectedDate =
                                                    await selectDate(context);
                                                if (selectedDate != null) {
                                                  selectedDate1 =
                                                      selectedDate.toString();
                                                  setState(() {});
                                                } else {
                                                  print(
                                                      "Lütfen Bir Tarih Seçiniz");
                                                }
                                              },
                                            ),
                                            FlatButton(
                                                color: Colors.blue,
                                                child: Text(
                                                    "Kurye Fotoğrafını Yükle"),
                                                textColor: Colors.white,
                                                onPressed: getImage),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FlatButton(
                                                color: Colors.green,
                                                child: Text("Kuryeyi Güncelle"),
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  productUpdate(
                                                      snapshot, index);
                                                }),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FlatButton(
                                                color: Colors.red,
                                                child: Text("Kuryeyi Sil"),
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  snapshot.data.docs[index]
                                                      .reference
                                                      .delete();
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                      ),
                      title: Text(
                        messengers['nameSurname'],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            messengers['phoneNumber'],
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            messengers['selectedDate'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      trailing: Image.network(
                        messengers['messengers'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  });
            } else {
              return Text(
                "Hiçbir Kurye Bulunamadı",
                style: TextStyle(color: Colors.black),
              );
            }
          }),
    );
  }
}
