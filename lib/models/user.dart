import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String photoUrl;
  final String fullname;
  final String email;
  final String bio;
  User({
    this.id,
    this.username,
    this.photoUrl,
    this.fullname,
    this.email,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      fullname: doc['fullname'],
      email: doc['email'],
      bio: doc['bio'],
    );
  }
}
