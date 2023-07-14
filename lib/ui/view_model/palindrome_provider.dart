import 'package:flutter/material.dart';

class PalindromeProvider extends ChangeNotifier {
  bool isPalindrome = false;

  void updateIsPalindrome(bool newIsPalindrome) {
    isPalindrome = newIsPalindrome;
    notifyListeners();
  }
}
