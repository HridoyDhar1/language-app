// class Teacher {
//   final String name;
//   final String language;
//   final String image;

//   Teacher({
//     required this.name,
//     required this.language,
//     required this.image,
//   });
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Teacher {
  final String id;
  final String name;
  final String description;
  final String language;
  final String image;
  final double price;
  final String location;
  final DateTime date;
  final TimeOfDay time;

  Teacher({
    required this.id,
    required this.name,
    required this.description,
    required this.language,
    required this.image,
    required this.price,
    required this.location,
    required this.date,
    required this.time,
  });

  factory Teacher.fromFirestore(Map<String, dynamic> data, String id) {
    return Teacher(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      language: data['language'] ?? 'English',
      image: data['image'] ?? 'https://via.placeholder.com/150',
      price: (data['price'] ?? 0.0).toDouble(),
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: data['time']['hour'] ?? 0,
        minute: data['time']['minute'] ?? 0,
      ),
    );
  }
}