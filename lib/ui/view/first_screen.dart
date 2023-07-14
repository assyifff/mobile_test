import 'package:flutter/material.dart';
import 'package:mobile_test/ui/util/color.dart';
import 'package:mobile_test/ui/view/second_screen.dart';
import 'package:mobile_test/ui/view_model/palindrome_provider.dart';
import 'package:mobile_test/ui/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sentenceController = TextEditingController();
  bool isPalindrome = false;

  bool checkPalindrome(String sentence) {
    String processedSentence = sentence.replaceAll(' ', '').toLowerCase();
    int length = processedSentence.length;
    for (int i = 0; i < length / 2; i++) {
      if (processedSentence[i] != processedSentence[length - i - 1]) {
        return false;
      }
    }
    return true;
  }

  void onCheckButtonPressed() {
    String sentence = sentenceController.text;
    bool isPalindrome = checkPalindrome(sentence);

    Provider.of<PalindromeProvider>(context, listen: false)
        .updateIsPalindrome(isPalindrome);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Result'),
        content: Text(isPalindrome ? 'isPalindrome' : 'Not Palindrome'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void onNextButtonPressed() {
    String name = nameController.text;
    Provider.of<UserProvider>(context, listen: false).updateSelectedTitle(name);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondScreen(name: name)),
    );
    nameController.clear();
    sentenceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 142,
            left: 32,
            right: 32,
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/ic_photo.png',
                        height: 116,
                        width: 116,
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.amber),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: sentenceController,
                        decoration: InputDecoration(
                          hintText: 'Palindrome',
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.amber),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 45),
                ElevatedButton(
                  onPressed: onCheckButtonPressed,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(310, 41),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(button),
                  ),
                  child: Text(
                    'CHECK',
                    style: TextStyle(color: buttonText),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onNextButtonPressed,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(310, 41),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(button),
                  ),
                  child: Text(
                    'NEXT',
                    style: TextStyle(color: buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
