import 'dart:io';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:ponto_movel/telas/home.dart';

class NovoRegistro extends StatelessWidget {
  const NovoRegistro(
      {super.key,
      required this.foto,
      required this.dataHora,
      required this.latitude,
      required this.longitude});

  final XFile foto;
  final DateTime dataHora;
  final double latitude;
  final double longitude;

  Future enviar() async {
    final fotoBytes = await File(foto.path).readAsBytes();
    final fotoB64 = base64.encode(fotoBytes);

    final futuro = await Supabase.instance.client.from('registros').insert({
      'user_id': Supabase.instance.client.auth.currentUser!.id,
      'data_hora': dataHora.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'foto': fotoB64
    }).select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Adicionar registro')),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.file(File(foto.path), fit: BoxFit.cover, width: 250),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.access_time_outlined),
                    Text(
                        ' ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}')
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.calendar_today),
                    Text(
                        ' ${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year}')
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.location_on_outlined),
                    Text(' $latitude, $longitude')
                  ]),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                              content: SizedBox(
                            height: 170,
                            width: 130,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: Expanded(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 6))),
                                  Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text('Registrando...',
                                          style: TextStyle(fontSize: 18)))
                                ]),
                          )));

                  await enviar().then((value) {
                    showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                    content: SizedBox(
                                  height: 170,
                                  width: 130,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle_outline_rounded,
                                            color: Colors.green, size: 120),
                                        Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Text('Registrado',
                                                style: TextStyle(fontSize: 18)))
                                      ]),
                                )),
                            barrierDismissible: false)
                        .timeout(
                      const Duration(seconds: 2),
                      onTimeout: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                    );
                  });
                },
                child: const Text('Registrar', style: TextStyle(fontSize: 18)),
              )
            ]));
  }
}
