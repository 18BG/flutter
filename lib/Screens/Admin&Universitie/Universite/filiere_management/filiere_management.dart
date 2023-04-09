import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FiliereManage extends StatefulWidget {
  Option option;
  FiliereManage({super.key, required this.option});

  @override
  State<FiliereManage> createState() => _FiliereManageState();
}

class _FiliereManageState extends State<FiliereManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.option.nom),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            //height: MediaQuery.of(context).size.width * 0.5,
            //color: Colors.red,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.black,
              child: Center(
                child: Image.memory(
                  widget.option.logo,
                  fit: BoxFit.contain,
                  width: 350,
                  height: 300,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              widget.option.commentaire,
              textScaleFactor: 1.3,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (BuildContext context, i) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text("data"),
                  ),
                );
              })
        ],
      )),
    );
  }
}
