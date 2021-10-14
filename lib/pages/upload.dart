import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File file;
  handleTakePhoto() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675.0,
      maxWidth: 960.0,
    );
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallary() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675.0,
      maxWidth: 960.0,
    );
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Photo with Camera"),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text("Image from Gallery"),
              onPressed: handleChooseFromGallary,
            ),
            SimpleDialogOption(
              child: Text("Cancle"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
              child: Text(
                "Upload Image",
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
              onPressed: () => selectImage(context),
            ),
          )
        ],
      ),
    );
  }

  buildUploadForm() {
    return Text("File loaded");
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
