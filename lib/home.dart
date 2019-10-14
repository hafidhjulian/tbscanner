import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'detail.dart';

const String TEXT_SCANNER = "TEXT_SCANNER";
const String BARCODE_SCANNER = "BARCODE_SCANNER";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _file;
  String _selectedScanner = TEXT_SCANNER;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text & Barcode Scanner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            title(),
            radioButton(),
            titleScan(),


          ],
        ),
      )
    );
  }

  Widget title() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16.0,
        ),
        child: Text(
          "Select Scanner Type",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget titleScan() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16.0,
        ),
        child: Text(
          "Pick Image",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget radioButton() {
    new Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile<String>(
            title: Text("Text Recognition"),
            groupValue: _selectedScanner,
            value: TEXT_SCANNER,
            onChanged: onScannerSelected,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: Text("Barcode Scanner"),
            groupValue: _selectedScanner,
            value: BARCODE_SCANNER,
            onChanged: onScannerSelected,
          ),
        )
      ],
    );
  }

  Widget selectImage(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0
            ),
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelection(CAMERA_SOURCE);
              },
              child: Text("Camera"),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0
            ),
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelection(GALLERY_SOURCE);
              },
              child: Text("Gallery"),
            ),
          ),
        )
      ],
    );
  }

  Widget buildImageRow(BuildContext context, File file) {
    return SizedBox(
      height: 500.0,
      child: Image.file(file, fit: BoxFit.fitWidth,)
    );
  }

  Widget buildDeleteRow(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              setState(() {
                _file = null;
              });
            },
            child: const Text('Delete Image')
        ),
      ),
    );
  }

  void onScannerSelected(String scanner) {
    setState(() {
      _selectedScanner = scanner;
    });
  }

  void onPickImageSelection(String source) async {
    var imageSource;
    if (source == CAMERA_SOURCE) {
      imageSource = ImageSource.camera;
    }else{
      imageSource = ImageSource.gallery;
    }
    final scaffold = _scaffoldKey.currentState;

    try{
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('file is not available');
      }
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => DetailWidget(file, _selectedScanner))
      );
    }catch(e){
      scaffold.showSnackBar(SnackBar(content: Text(e.toString()),));
    }
  }
}

