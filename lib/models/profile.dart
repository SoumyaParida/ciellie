import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class UserProfile {
  String image;
  String name;
  String email;
  String phone;
  String id;

  UserProfile({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
  });

  UserProfile copy({
    String? imagePath,
    String? name,
    String? phone,
    String? email,
    String? id,
  }) =>
      UserProfile(
        image: imagePath ?? this.image,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        id: id ?? this.id,
      );

  UserProfile.fromFirebaseUser(fb_auth.User fbUser, String name, String phone, String image)
      : id = fbUser.uid,
        name = name,
        email = fbUser.email!,
        phone = phone,
        image = image;

  /*UserProfile.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        email = snapshot['email'],
        phone = snapshot['phone'],
        image = snapshot['image'];
  */
  factory UserProfile.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data();
    return UserProfile(id: data!["id"], image: data["image"], 
                      name: data["name"], email: data["email"], phone: data["phone"]);
  }

  UserProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        image = json['image'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email, 'phone': phone, 'image':image};

  @override
  String toString() {
    return 'User{id: $id, username: $name, email: $email, phone: $phone, image: $image}';
  }
}
