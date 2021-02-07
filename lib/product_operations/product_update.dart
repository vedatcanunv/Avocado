import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UrunGuncelle extends StatefulWidget {
  @override
  _UrunGuncelleState createState() => _UrunGuncelleState();
}

class _UrunGuncelleState extends State<UrunGuncelle> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Urunler');
  TextEditingController urunAdi = TextEditingController();
  TextEditingController urunMiktar = TextEditingController();
  TextEditingController urunFiyat = TextEditingController();
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
        _firebaseStorage.ref().child('urunler').child(urunAdi.text);
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  void urunGuncelle(snapshot, index) async {
    String urunURL = await uploadFile(_image);
    snapshot.data.docs[index].reference.update({
      'urunAdi': urunAdi.text,
      'urunMiktari': urunMiktar.text,
      'urunFiyat': urunFiyat.text,
      'urunURL': urunURL
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: Colors.green[100],
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var urunUzunluk = snapshot.data.docs.length;
              return ListView.builder(
                  itemCount: urunUzunluk,
                  itemBuilder: (context, index) {
                    var urunler = snapshot.data.docs[index];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.black,
                        onPressed: () {
                          urunAdi.text = urunler['urunAdi'];
                          urunMiktar.text = urunler['urunMiktari'];
                          urunFiyat.text = urunler['urunFiyat'];
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  color: Colors.indigo,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        _image == null
                                            ? Text('No image selected.')
                                            : Image.file(_image),
                                        TextField(
                                          controller: urunAdi,
                                          style:
                                          TextStyle(color: Colors.blue),
                                          cursorColor: Color(0xFF9b9b9b),
                                          decoration: InputDecoration(
                                              hintText:
                                              "Ürünün Adını Giriniz",
                                              hintStyle: TextStyle(
                                                color: Color(0xFF9b9b9b),
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.normal,
                                              )),
                                        ),
                                        TextField(
                                          controller: urunFiyat,
                                          style:
                                          TextStyle(color: Colors.blue),
                                          cursorColor: Color(0xFF9b9b9b),
                                          decoration: InputDecoration(
                                            hintText:
                                            "Ürün Fiyatını Giriniz",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          controller: urunMiktar,
                                          style:
                                          TextStyle(color: Colors.blue),
                                          cursorColor: Color(0xFF9b9b9b),
                                          decoration: InputDecoration(
                                            hintText:
                                            "Ürünün Miktarını Giriniz",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                            color: Colors.blue,
                                            child: Text("Resim Yükle"),
                                            textColor: Colors.white,
                                            onPressed: getImage),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FlatButton(
                                            color: Colors.green,
                                            child: Text("Ürünü Güncelle"),
                                            textColor: Colors.white,
                                            onPressed: () {
                                              urunGuncelle(snapshot, index);
                                            }),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FlatButton(
                                            color: Colors.red,
                                            child: Text("Ürünü Sil"),
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
                        urunler['urunAdi'],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            urunler['urunFiyat'],
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            urunler['urunMiktari'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      trailing: Image.network(
                        urunler["urunURL"],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  });
            } else {
              return Text(
                "Olmuyor",
                style: TextStyle(color: Colors.black),
              );
            }
          }),
    );
  }
}
