import 'dart:convert';
import 'package:flutter/material.dart';

class Serializer {
  String serializeColor(Color color) {
    return '{"r": {color.red}, "g": ${color.green}, "b": ${color.blue}, "o": ${color.opacity}}';
  }

  Color unserializeColor(String color) {
    Map<String, Object> decodedColor = jsonDecode(color);
    return Color.fromRGBO(decodedColor['r'], decodedColor['g'],
        decodedColor['b'], decodedColor['o']);
  }
}
