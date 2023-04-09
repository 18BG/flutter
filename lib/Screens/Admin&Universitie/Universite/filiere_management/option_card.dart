import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/option_fetcher.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatefulWidget {
  final Option option;
  const OptionCard(this.option, {super.key});

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(widget.option.nom),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
    );
  }
}
