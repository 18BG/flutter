import 'dart:io';

import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatefulWidget {
  final Universite faculte;
  const HomePageBody({super.key, required this.faculte});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final Map<String, Widget> items = {
    'Présentation': const Icon(Icons.screen_share),
    'Informations': const Icon(Icons.info),
    'Filières': const Icon(Icons.school),
    'Options': const Icon(Icons.book),
    'Item 5': const Icon(Icons.h_mobiledata),
  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.7,
                    child: Card(
                      color: Colors.black,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Image.memory(
                          widget.faculte.logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                widget.faculte.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.04,
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(12),
                            bottomStart: Radius.elliptical(15, 12)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromARGB(127, 0, 0, 0),
                              Color.fromARGB(255, 84, 226, 212)
                            ])),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          items.values.elementAt(index),
                          Text(items.keys.elementAt(index))
                        ],
                      ),
                    ),
                  );
                }),
          )
        ]),
      ),
    );
  }
}
