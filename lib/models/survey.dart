import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/models/user.dart';

class Survey {
  /*final String id;
  final String name;
  final User creator;
  final DateTime createdAt;
  final int totalVoteCount;*/

  final String name;
  final User creator;
  final String email;
  final String phoneNumber;
  final String address;
  String? propertyType;
  
  final String id;

  Survey(this.id, this.name, this.creator, this.email, this.phoneNumber, this.address, this.propertyType);

  Survey.fromDocSnapshot(DocumentSnapshot snapshot, User creator)
      : id = snapshot.id,
        name = snapshot['name'],
        creator = creator,
        email = snapshot['email'],
        phoneNumber = snapshot['phoneNumber'],
        address = snapshot['address'];

  @override
  String toString() {
    return 'Survey{id: $id, name: $name,  creator: $creator, email: $email, phoneNumber: $phoneNumber, address: $address}';
  }
}
