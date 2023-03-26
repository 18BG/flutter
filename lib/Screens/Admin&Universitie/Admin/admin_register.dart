import 'package:an_app/Screens/Admin&Universitie/Admin/register_body.dart';
import 'package:flutter/material.dart';

class AdminRegister extends StatelessWidget {
  const AdminRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Guide de L'etudiant"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: const AdminRegisterBody(),
    );
  }
}
