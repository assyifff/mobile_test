import 'package:flutter/material.dart';
import 'package:mobile_test/ui/util/color.dart';
import 'package:mobile_test/ui/view/third_screen.dart';
import 'package:mobile_test/ui/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class SecondScreen extends StatefulWidget {
  final String? name;

  const SecondScreen({Key? key, this.name}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool dataFromThirdScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Second Screen',
          style: TextStyle(color: appBarText),
        ),
        backgroundColor: buttonText,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: appBarText,
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, provider, child) {
        if (!dataFromThirdScreen) {
          Future.delayed(Duration.zero, () {
            provider.updateSelectedTitle(null);
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome'),
                  Text(
                    widget.name ?? 'John Doe',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 222),
            Center(
                child: Text(
              provider.selectedTitle ?? 'Selected User Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 300),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThirdScreen(
                        selectedTitle: provider.selectedTitle ?? '',
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      dataFromThirdScreen = true;
                    });
                    provider.updateSelectedTitle(result);
                  }
                },
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
            ),
          ],
        );
      }),
    );
  }
}
