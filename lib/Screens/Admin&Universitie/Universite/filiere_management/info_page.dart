import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/iniversities%20model/info_model.dart';
import 'package:an_app/model/iniversities%20model/serie_model.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final Info info;
  const InfoPage({super.key, required this.info});

  @override
  State<InfoPage> createState() => _FieldPageState();
}

class _FieldPageState extends State<InfoPage> {
  final key = GlobalKey<FormState>();

  List<Serie> serie = [];
  TextEditingController nom = TextEditingController();

  bool isLoading = false;
  bool isProcessing = false;
  String current = "";
  Serie? serieToEvaluate;
  String? check(String? value) {
    if (value!.isEmpty) {
      return 'Champs obligatoire';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.info.titre)),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: Card(
              color: Colors.amber,
              child: Image.memory(
                widget.info.image,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: CustomText(
              widget.info.contenue,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      )),
    );
  }
}
