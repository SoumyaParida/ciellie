import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class Survey {
  String name;
  String email;
  String phone;
  String address;
  String propertyType;
  String date;
  String time;
  String message;
  String id;
  
  Survey({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.propertyType,
    required this.date,
    required this.time,
    required this.message,
  });

  Survey copy({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? propertyType,
    String? date,
    String? time,
    String? message,
    String? id,
  }) =>
      Survey(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        propertyType: propertyType ?? this.propertyType,
        date: date ?? this.date,
        time: time ?? this.time,
        message: message ?? this.message,
        id: id ?? this.id,
      );

  Survey.fromFirebaseUser(fb_auth.User fbUser, String name, String phone, String address, String propertyType, String date, String time, String message)
      : id = fbUser.uid,
        name = name,
        email = fbUser.email!,
        phone = phone,
        address = address,
        propertyType = propertyType,
        date = date,
        time = time,
        message = message;

  factory Survey.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data();
    return Survey(id: data!["id"], 
                  name: data["name"], 
                  email: data["email"], 
                  phone: data["phone"],
                  address: data["address"], 
                  propertyType: data["propertyType"],
                  date: data["date"], 
                  time: data["time"], 
                  message: data["message"]
                  );
  }

  Survey.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        address = json['address'],
        propertyType = json['propertyType'],
        date = json['date'],
        time = json['time'],
        message = json['message'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email, 'phone': phone, 'address':address, 
      'propertyType':propertyType, 'date':date,'time':time, 'message':message};

  @override
  String toString() {
    return 'User{id: $id, username: $name, email: $email, phone: $phone, address: $address,propertyType: $propertyType, date: $date, time: $time, message: $message}';
  }
}

