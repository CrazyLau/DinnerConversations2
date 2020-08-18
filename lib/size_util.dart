import 'dart:math';

import 'package:flutter/cupertino.dart';

class SizeUtil{

  static double getPercentScreenWidth(context, double percentScreen) {
    return MediaQuery.of(context).size.width * percentScreen;
  }

  static double getPercentScreenHeight(context, double percentScreen) {
    return MediaQuery.of(context).size.height * percentScreen;
  }

  static double FI() {
    return 2/(1+sqrt(5));
  }

}