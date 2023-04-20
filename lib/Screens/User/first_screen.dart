import 'package:an_app/Screens/User/ancien/ancien_bachelier.dart';
import 'package:an_app/Screens/User/autre/fetchAllUniv.dart';
import 'package:an_app/Screens/User/nouveau/nouveau_bachelier.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isCharging = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: (isCharging)
                  ? null
                  : () async {
                      setState(() {
                        isCharging = true;
                      });

                      await Sqflite().getDataAgain();

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Données mise à jour")));

                      setState(() {
                        isCharging = false;
                      });
                    },
              child: const Text(
                "Récharger",
                style: TextStyle(color: Colors.teal),
              ))
        ],
      ),
      body: (isCharging)
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "Cette opération peut prendre du temps",
                  factor: 2.0,
                ),
                const SizedBox(
                  height: 15,
                ),
                const CircularProgressIndicator.adaptive(),
              ],
            ))
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(17, 117, 177, 1),
                    Color.fromRGBO(73, 182, 172, 1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Bienvenue!',
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Text(
                      'Commencez votre recherche universitaire dès maintenant',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Insérer l'action souhaitée ici
                        //dialogue();
                        _showDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: Text(
                        'Commencez!',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    title: const Text('Je viens juste d\'avoir le bac'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const NouveauBachelier();
                      }));
                    },
                  ),
                ),
                Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    title: const Text('Je suis déjà à l\'université'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const AncienBachelier();
                      }));
                    },
                  ),
                ),
                Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    title: const Text('Autre'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return FetchAllUniv();
                      }));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        // Do something with the selected value
        print('Selected status: $value');
      }
    });
  }

  void dialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text('Choisissez votre profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: Text('Je viens juste d\'avoir le bac'),
                onPressed: () {
                  // Action à effectuer
                },
              ),
              TextButton(
                child: Text('Je suis déjà à l\'université'),
                onPressed: () {
                  // Action à effectuer
                },
              ),
              TextButton(
                child: Text('Autre'),
                onPressed: () {
                  // Action à effectuer
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
