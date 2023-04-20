import 'package:flutter/material.dart';

class Padd {
  Padding padd(int n) {
    if (n == 0) {
      return const Padding(padding: EdgeInsets.all(20.0));
    } else if (n == 1) {
      return const Padding(padding: EdgeInsets.only(top: 20.0));
    } else {
      return const Padding(padding: EdgeInsets.only(bottom: 20.0));
    }
  }
}
