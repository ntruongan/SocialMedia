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
    // getUser();
    //createUser();
    updateUser();
    deleteUser();
    super.initState();
  }

  // createUser() async {
  //   usersRef.add({
  //     "fullname": "An FE ",
  //     "isAdmin": false,
  //     "postcount": 21,
  //     "username": "am123"
  //   });
  // }
  deleteUser() async {
    // usersRef.document("fsf12312wsa").delete();
    final doc = await usersRef.document("fsf1w2312wsa").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  updateUser() async {
    final doc = await usersRef.document("fsf1w2312wsa").get();
    if (doc.exists) {
      doc.reference.updateData({"fullname": "An FE now"});
    }
  }

  createUser() async {
    // usersRef.document("fsf12312wsa").setData({
    //   // create with my own id
    //   "fullname": "An FE ",
    //   "isAdmin": false,
    //   "postcount": 21,
    //   "username": "am123"
    // });
    final doc = await usersRef.document("fsf1w2312wsa").get();
    if (!doc.exists) {
      usersRef.document("fsf1w2312wsa").setData({
        // create with my own id
        "fullname": "An FE 12 ",
        "isAdmin": false,
        "postcount": 21,
        "username": "am123"
      });
    }
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
      body: StreamBuilder<QuerySnapshot>(
          stream: usersRef.snapshots(),
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
