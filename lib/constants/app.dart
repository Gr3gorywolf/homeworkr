import 'package:flutter/foundation.dart';

class AppConstants {
  static  String kStripeToken = kReleaseMode
      ? "pk_test_51ILzE0JZOgGAQ3vFXAuuXci7A5BopTdHSDP5tjBVq9SVvG1uhWsdTAiN0yrUwXdG8SNAgq6nGw0KtwaK5iIzwEEA00yzlLVaYO"
      : "pk_test_51ILzE0JZOgGAQ3vFXAuuXci7A5BopTdHSDP5tjBVq9SVvG1uhWsdTAiN0yrUwXdG8SNAgq6nGw0KtwaK5iIzwEEA00yzlLVaYO";
  final String kMerchantId = kReleaseMode ? "test" : "test";
  final String kPayMode = kReleaseMode ? 'test' : 'test';
  static String kBaseUrl = kReleaseMode ? 'https://homeworkr.gregoryc.dev' : 'http://10.0.0.23:5005';
}
