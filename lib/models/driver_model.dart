import 'package:flutter/foundation.dart';

class Driver {
  Driver({
    @required this.id,
    @required this.name,
    @required this.email,
    this.phone,
    this.avatarUrl,
    this.favourite,
  });

  String id;
  String name;
  String email;
  String avatarUrl;
  String phone;
  bool favourite;

  factory Driver.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final String email = data['email'];
    final String avatarUrl = data['avatarUrl'];
    final String phone = data['phone'];
    final bool favourite = data['favourite'];

    return Driver(
      id: documentId,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      phone: phone,
      favourite: favourite,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      "phone": phone,
      "favourite": favourite,
    };
  }
}
