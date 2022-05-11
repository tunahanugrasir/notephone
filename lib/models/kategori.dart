class Kategori {
  int? kategoriID;
  String? kategoriAdi;

  //kategori eklerken kullanılacak çünkü ID db tarafından otomatik ekleniyor
  Kategori({this.kategoriAdi});
  //isimlendirilmiş constructor
  //kategorileri dbden okurken kullanılacak
  Kategori.withID({this.kategoriID, this.kategoriAdi});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['kategoriID'] = kategoriID;
    map['kategoriAdi'] = kategoriAdi;
    return map;
  }

  //isimlendirilmiş constructorlara return yazmıyoruz
  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriID = map['kategoriID'];
    this.kategoriAdi = map['kategoriAdi'];
  }

  @override
  String toString() {
    return 'Kategori{kategoriID: $kategoriID, kategoriAdi: $kategoriAdi}';
  }
}
