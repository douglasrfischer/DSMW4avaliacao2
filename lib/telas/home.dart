import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:ponto_movel/telas/foto.dart';
import 'package:ponto_movel/telas/historico.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String sexo = 'F';
  String nome = 'Carla';
  String ultimo_registro = '07/09 08:30';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 23),
                child: Text(
                  sexo == 'M' ? 'Bem-vindo, $nome' : 'Bem-vinda, $nome',
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.more_time_rounded),
                            Text(
                              ' Adicionar registro',
                              style: TextStyle(
                                  color: Color.fromRGBO(3, 80, 166, 1)),
                            )
                          ])),
                  onPressed: () async {
                    await availableCameras().then((listaCameras) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Foto(cameras: listaCameras)));
                    },);
                  },
                )),
            OutlinedButton(
              child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.work_history_outlined),
                        Text(' Histórico',
                            style:
                                TextStyle(color: Color.fromRGBO(3, 80, 166, 1)))
                      ])),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Historico()));
              },
            ),

            Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text('Último registro: $ultimo_registro',
                    style: const TextStyle(color: Colors.black38))),
          ]),
        ));
  }
}
