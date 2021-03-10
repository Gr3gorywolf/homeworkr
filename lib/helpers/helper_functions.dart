import 'package:intl/intl.dart';

class HelperFunctions{
  static String parseEnumVal(val){
    return  val.toString().split('.').last;
  }

  static formatNumber(int number){
       final formatter = new NumberFormat("#,###");
        return formatter.format(number);
  }
}