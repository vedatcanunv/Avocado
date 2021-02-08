import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductUpdate extends StatefulWidget {
  @override
  _ProductUpdateState createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Products');
  TextEditingController name = TextEditingController();
  TextEditingController kilo = TextEditingController();
  TextEditingController price = TextEditingController();
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
        _firebaseStorage.ref().child('Products').child(name.text);
    var uploadTask = _storageReference.putFile(uploadingFile);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  void productUpdate(snapshot, index) async {
    String image = await uploadFile(_image);
    snapshot.data.docs[index].reference.update({
      'name': name.text,
      'kilo': kilo.text,
      'price': price.text,
      'image': image
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Ürün Güncelleme Ekranı"),
      ),
      backgroundColor: Colors.green[100],
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              var productLength = snapshot.data.docs.length;
              return ListView.builder(
                  itemCount: productLength,
                  itemBuilder: (context, index) {
                    var products = snapshot.data.docs[index];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.black,
                        onPressed: () {
                          name.text = products['name'];
                          kilo.text = products['kilo'];
                          price.text = products['price'];
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            _image == null
                                                ? Text('No image selected.')
                                                : Image.file(_image),
                                            TextField(
                                              controller: name,
                                              style: TextStyle(
                                                  color: Colors.green),
                                              cursorColor: Color(0xFF1B5E20),
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "Ürünün Adını Giriniz",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFF1B5E20),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  )),
                                            ),
                                            TextField(
                                              controller: price,
                                              style: TextStyle(
                                                  color: Colors.green),
                                              cursorColor: Color(0xFF1B5E20),
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Ürün Fiyatını Giriniz",
                                                hintStyle: TextStyle(
                                                  color: Color(0xFF1B5E20),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            TextField(
                                              controller: kilo,
                                              style: TextStyle(
                                                  color: Colors.green),
                                              cursorColor: Color(0xFF1B5E20),
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Ürünün Miktarını Giriniz",
                                                hintStyle: TextStyle(
                                                  color: Color(0xFF1B5E20),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                                color: Colors.green,
                                                child: Text("Resim Yükle"),
                                                textColor: Colors.green[200],
                                                onPressed: getImage),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FlatButton(
                                                color: Colors.green,
                                                child: Text("Ürünü Güncelle"),
                                                textColor: Colors.green[200],
                                                onPressed: () {
                                                  productUpdate(
                                                      snapshot, index);
                                                }),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FlatButton(
                                                color: Colors.green[900],
                                                child: Text("Ürünü Sil"),
                                                textColor: Colors.green[200],
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
                        products['name'],
                        style: TextStyle(color: Colors.green[900]),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            products['price'],
                            style: TextStyle(color: Colors.green[900]),
                          ),
                          Text(
                            products['kilo'],
                            style: TextStyle(color: Colors.green[900]),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      trailing: Image.network(
                        products["image"],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
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
    );
  }
}
