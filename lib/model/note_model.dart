import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({required this.text});

  final String text;

  Map<String, dynamic> toMap() =>
      {"text": text, "createdAt": Timestamp.now()};

  // String toJson() => json.encode(toMap());
}
