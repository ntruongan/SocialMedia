import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/header.dart';
import 'package:flutter_application_1/widgets/progress.dart';

final CollectionReference usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() {
    usersRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        print(doc.data);
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: circularProgress(),
    );
  }
}
