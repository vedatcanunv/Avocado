import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KuryeGuncelle extends StatefulWidget {
  @override
  _KuryeGuncelleState createState() => _KuryeGuncelleState();
}

class _KuryeGuncelleState extends State<KuryeGuncelle> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Kuryeler');
  TextEditingController kuryeAdSoyadi = TextEditingController();
  TextEditingController kuryeTelNo = TextEditingController();
  String secilenTarih1;
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

  Future<String> uploadFile(File yuklenecekDosya) async {
    _storageReference =
        _firebaseStorage.ref().child('Kuryeler').child('adSoyad');
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  void urunGuncelle(snapshot, index) async {
    String kuryeURL = await uploadFile(_image);
    snapshot.data.docs[index].reference.update({
      'adSoyad': kuryeAdSoyadi.text,
      'girisTarih': secilenTarih1,
      'kuryeFotograf': kuryeURL,
      'kuryeTelNo': kuryeTelNo.text,
    }).whenComplete(() => Navigator.pop(context));
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.blue,
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var kuryeuzunluk = snapshot.data.docs.length;
              return ListView.builder(
                  itemCount: kuryeuzunluk,
                  itemBuilder: (context, index) {
                    var kuryeler = snapshot.data.docs[index];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.black,
                        onPressed: () {
                          kuryeAdSoyadi.text = kuryeler['adSoyad'];
                          secilenTarih1 = kuryeler['girisTarih'];
                          kuryeTelNo.text = kuryeler['kuryeTelNo'];
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
                                          controller: kuryeAdSoyadi,
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
                                          controller: kuryeTelNo,
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
                                            secilenTarih =
                                            await tarihSec(context);
                                            if (secilenTarih != null) {
                                              secilenTarih1 =
                                                  secilenTarih.toString();
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
                                              urunGuncelle(snapshot, index);
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
                        kuryeler['adSoyad'],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            kuryeler['kuryeTelNo'],
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            kuryeler['girisTarih'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      trailing: Image.network(
                        kuryeler['kuryeFotograf'],
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
