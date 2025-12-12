import 'package:flutter/material.dart';

class FrescarPage extends StatefulWidget {
  const FrescarPage({super.key});

  @override
  State<FrescarPage> createState() => _FrescarPageState();
}

class _FrescarPageState extends State<FrescarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mancho tu acha que um app feito por mim vai ter termos e condições?? kkkkk",
                style: TextStyle(fontSize: 30)),

            Icon(Icons.accessible_forward_outlined)
          ],
        ),
      ),
    );
  }
}
