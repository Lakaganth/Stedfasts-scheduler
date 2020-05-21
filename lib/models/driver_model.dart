import 'package:flutter/foundation.dart';

class Driver {
  Driver({
    @required this.id,
    @required this.name,
    @required this.email,
    this.avatarUrl,
  });

  String id;
  String name;
  String email;
  String avatarUrl;

  factory Driver.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final String email = data['email'];
    final String avatarUrl = data['avatarUrl'];

    return Driver(
      id: documentId,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
