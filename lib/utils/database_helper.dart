import 'dart:io';
import 'package:flutter/services.dart';
import 'package:notephone/models/kategori.dart';
import 'package:notephone/models/not.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';

//bu sınıf veritabanıyla ilgili bütün işlemlerimizi gerçekleştirebileceğimiz bir sınıf
class Databasehelper {
  //static: sınıfa özgü özellikler yani _databaseHelper kullanılması için nesne üretmeden direkt sınıf adını çağırarak kullanabiliriz
  static Databasehelper? _databaseHelper;
  static Database? _database;

  factory Databasehelper() {
    if (_databaseHelper == null) {
      _databaseHelper = Databasehelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }

  Databasehelper._internal() {}

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database? _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "appDB.db");
          var file = new File(path);
          //dosyanın var olup olmadığını kontol ediyoruz
          if (!await file.exists()) {
            //assetten kopyalıyoruz
            ByteData data = await rootBundle.load(join("assets", "notlar.db"));
            print("oluşacak database pathi $path");
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          //database açıyoruz
          _db = await openDatabase(path);
        }
      });
    }
    return _db!;
  }

  //KATEGORİLERLE İLGİLİ İŞLEMLER

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = db.update("kategori", kategori.toMap(),
        where: 'kategoriID = ?', whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase();
    var sonuc =
        db.delete("kategori", where: 'kategoriID = ?', whereArgs: [kategoriID]);
    return sonuc;
  }

  //NOTLARLA İLGİLİ İŞLEMLER

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("not", orderBy: 'notID DESC');
    return sonuc;
  }

  Future<int> notEKle(Not not) async {
    var db = await _getDatabase();
    var sonuc = db.insert("not", not.toMap());
    return sonuc;
  }

  Future<int> notlariGuncelle(Not not) async {
    var db = await _getDatabase();
    var sonuc = db
        .update("not", not.toMap(), where: 'notID = ?', whereArgs: [not.notID]);
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sonuc = db.delete("not", where: 'notID = ?', whereArgs: [notID]);
    return sonuc;
  }
}
