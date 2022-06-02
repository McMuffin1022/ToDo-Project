import 'package:flutter/cupertino.dart';

class Type {
  final int? ID_Type;
  final String? TypeName;
  final String? TypeColor;

  Type(
      {this.ID_Type, required this.TypeName, required this.TypeColor});

  Map<String, dynamic> toMap() {
    return {'ID_Type': ID_Type, 'TypeName': TypeName, 'TypeColor': TypeColor};
  }
}
