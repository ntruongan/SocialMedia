import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/search.dart';
import 'package:flutter_application_1/widgets/header.dart';
import 'package:flutter_application_1/widgets/progress.dart';

final CollectionReference usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() async {
    String field = "isAdmin";
    final QuerySnapshot snapshot =
        await usersRef.where(field, isEqualTo: true).getDocuments();

    setState(() {
      users = snapshot.documents;
    });
    // snapshot.documents.forEach((element) {
    //   print(element.data);
    //   print(element.documentID);
    // });
  }

  getUserById() async {
    final String id = "ShmU2jCV3Hjv7UPdzNkV";
    DocumentSnapshot doc = await usersRef.document(id).get();
    print(doc.documentID);
    print(doc.data);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: FutureBuilder<QuerySnapshot>(
          future: usersRef.getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            final List<Text> children = snapshot.data.documents
                .map((doc) => Text(doc['fullname']))
                .toList();
            return Container(
              child: ListView(children: children),
            );
          }),
    );
  }
}
