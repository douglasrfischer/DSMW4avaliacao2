import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ponto_movel/modelos/Registro.model.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  //late final List<Registro> historico;
  //late final int tamHistorico;

  final Future _historico = Future.microtask(
      // Microtasks = "Futures que são executados assim que possível, antes dos Futures
      // de construtor regular" para mais detalhes ler sobre event loop no dart.
      () => Supabase.instance.client
          .from('registros')
          .select()
          .order('data_hora'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Histórico')),
        body: FutureBuilder(
          future: _historico,
          builder: (context, snapshot) {
            Widget exibicao;

            if (snapshot.hasData) {
              exibicao = ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RegistroCard(
                        registro: Registro.fromJson(snapshot.data[index]));
                  });
            } else {
              exibicao = const Center(
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator()));
            }

            return Center(
                child: Column(children: <Widget>[Expanded(child: exibicao)]));
          },
        ));
  }
}

// -------------------------------------------------------------

class RegistroCard extends StatelessWidget {
  const RegistroCard({super.key, required this.registro});

  final Registro registro;

  void dialogoMotivo(BuildContext context) {
    final motivoController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text('Adicionar justificativa'),
                content: TextField(
                  controller: motivoController,
                  maxLines: 10,
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        // aparentemente motivoController.dispose() é desnecessário em diálogos
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: const Text('Adicionar'),
                      onPressed: () async {
                        await Supabase.instance.client
                            .from('registros')
                            .update({'motivo': motivoController.text})
                            .eq('user_id',
                                Supabase.instance.client.auth.currentUser!.id)
                            .eq('id', registro.id);

                        Navigator.pop(context);
                      })
                ]),
        barrierDismissible: false);
  }

  void dialogoDetalhe(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Detalhes de registro'),
              content: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.memory(registro.fotoBytes),
                    )),
                Row(children: [
                  const Icon(Icons.calendar_today),
                  Text(' ${registro.data}')
                ]),
                Row(children: [
                  const Icon(Icons.access_time_outlined),
                  Text(' ${registro.hora}')
                ]),
                Row(children: [
                  const Icon(Icons.location_on_outlined),
                  Text(' ${registro.latitude}, ${registro.longitude}')
                ]),
                registro.motivo == null
                    ? TextButton(
                        child: const Row(children: [
                          Icon(Icons.edit_note_outlined),
                          Text('Editar')
                        ]),
                        onPressed: () {
                          dialogoMotivo(context);
                        },
                      )
                    : Row(children: [
                        const Icon(Icons.notes_outlined),
                        Text(' ${registro.motivo}')
                      ])
              ]),
              actions: [
                TextButton(
                    child: const Text('Fechar'),
                    onPressed: () => Navigator.pop(context))
              ],
            ),
        barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            dialogoDetalhe(context);
          },
          child: SizedBox(
              height: 50,
              width: 70,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(// Data
                        children: [
                      const Icon(Icons.calendar_today),
                      Text(' ${registro.data}',
                          style: const TextStyle(fontSize: 18))
                    ]),
                    Row(// Hora
                        children: [
                      const Icon(Icons.access_time_outlined),
                      Text(' ${registro.hora}',
                          style: const TextStyle(fontSize: 18))
                    ])
                  ]))),
    );
  }
}
