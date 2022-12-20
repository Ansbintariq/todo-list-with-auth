import 'package:flutter/material.dart';

class BoxUpdate extends StatefulWidget {
  const BoxUpdate({super.key});

  @override
  State<BoxUpdate> createState() => _BoxUpdateState();
}

class _BoxUpdateState extends State<BoxUpdate> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        height: 300,
        child: AlertDialog(
          actions: [
            Text("hello"),
            TextField(
              decoration: InputDecoration(label: Text("item")),
            ),
            TextField(
              decoration: InputDecoration(label: Text("price")),
            )
          ],
        ),
      ),
    );
  }
}
