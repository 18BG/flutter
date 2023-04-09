import 'package:flutter/material.dart';

import '../../../../model/iniversities model/class_option.dart';
import '../Screens/Admin&Universitie/Universite/filiere_management/option_management.dart';

class OptionFetcher extends StatelessWidget {
  const OptionFetcher({
    Key? key,
    required this.optionList,
    required this.widget,
  }) : super(key: key);

  final List<Option> optionList;
  final OptionManagement widget;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: optionList.length,
          itemBuilder: (BuildContext context, i) {
            return ListTile(
              title: Text(widget.faculty.name),
            );
          }),
    );
  }
}
