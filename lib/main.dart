import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notephone/models/kategori.dart';
import 'package:notephone/not_detay.dart';
import 'package:notephone/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var databaseHelper = Databasehelper();
    databaseHelper.kategorileriGetir();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NotePhone',
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatefulWidget {
  const NotListesi({Key? key}) : super(key: key);

  @override
  _NotListesiState createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  Databasehelper databasehelper = Databasehelper();
  var _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("NOTEPHONE"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
              heroTag: 'NotEkle',
              tooltip: 'Not Ekle',
              child: Icon(Icons.book),
              onPressed: () => _notDetaySayfasinaGit(context)),
          FloatingActionButton(
            heroTag: 'KategoriEkle',
            tooltip: 'Kategori Ekle',
            onPressed: () {
              kategoriKaydet(context);
            },
            child: Icon(
              Icons.add_outlined,
              size: 35,
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }

  Future<dynamic> kategoriKaydet(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String? yeniKategoriAdi;
    return showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return SimpleDialog(
            elevation: 15,
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(15),
            title: Form(
                key: formKey,
                child: TextFormField(
                  validator: (girilenKategoriAdi) {
                    if (girilenKategoriAdi!.length < 1) {
                      return 'Lütfen kategori adı girin';
                    }
                  },
                  onSaved: (yeniDeger) {
                    yeniKategoriAdi = yeniDeger!;
                  },
                  decoration: InputDecoration(labelText: 'Kategori Adı'),
                )),
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Vazgeç")),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          databasehelper
                              .kategoriEkle(
                                  Kategori(kategoriAdi: yeniKategoriAdi))
                              .then((kategoriID) {
                            if (kategoriID > 0) {
                              _scaffoldKey.currentState?.showSnackBar(SnackBar(
                                  duration: Duration(seconds: 2),
                                  content:
                                      Text("Kategori eklendi $kategoriID")));
                              debugPrint('Kategori Eklendi $kategoriID');
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      child: Text("Kaydet")),
                ],
              )
            ],
          );
        });
  }

  _notDetaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetaySayfasi(
                  baslik: 'Yeni Not',
                )));
  }
}
