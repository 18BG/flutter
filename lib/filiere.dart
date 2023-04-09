import 'package:flutter/material.dart';

List<String> fliere = ['LGL', 'LRT'];

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<String> filiere = ['LGL', 'LRT'];
  String current = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("MyApp"),
        ),
        body: Center(
          child: Column(
            children: [
              DropdownButton(
                  items: filiere
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      current = newValue!;
                    });
                  }),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                current,
                style: const TextStyle(fontSize: 25, color: Colors.teal),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text("Les filieres")
            ],
          ),
        ),
      ),
    );
  }
}
