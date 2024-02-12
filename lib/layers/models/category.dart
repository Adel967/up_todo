import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Category extends Equatable {
  final String? id;
  final String title;
  final IconData icon;
  final Color color;

  Category(
      {this.id, required this.title, required this.icon, required this.color});

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'icon': this.icon.codePoint,
      'color': this.color.value,
    };
  }

  factory Category.fromMap(QueryDocumentSnapshot map) {
    return Category(
      id: map.id,
      title: map['title'] as String,
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [this.title, this.icon, this.color];
}
