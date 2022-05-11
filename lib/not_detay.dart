import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotDetaySayfasi extends StatefulWidget {
  String? baslik;
  NotDetaySayfasi({this.baslik});

  @override
  _NotDetaySayfasiState createState() => _NotDetaySayfasiState();
}

class _NotDetaySayfasiState extends State<NotDetaySayfasi> {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.baslik!),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Card(),
          ],
        ),
      ),
    );
  }
}
