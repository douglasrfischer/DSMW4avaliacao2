import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

import 'package:ponto_movel/telas/novo_registro.dart';

class Foto extends StatefulWidget {
  const Foto({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<Foto> createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late DateTime dataHora;
  late double latitude;
  late double longitude;
  bool _cameraTraseiraSelecionada = false;

  void obterDataEHora() {
    setState(() {
      dataHora = DateTime.now();
    });
  }

  Future<void> obterLocal() async {
    // Vibe check
    // ------------------------------------------------------------------------
    bool gpsHabilitado;
    LocationPermission permissao;

    gpsHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!gpsHabilitado) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('GPS desabilitado'),
                content: Text(
                    'Habilite o serviço de localização antes de continuar'),
                actions: [
                  TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.pop(context))
                ],
              ),
          barrierDismissible: false);
      return Future.error('Serviço de localização desabilitado.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text('Permissão negada'),
                  content: Text(
                      'O aplicativo não recebeu permissão para utilizar o serviço de localização. Altere as permissões do aplicativo antes de prosseguir.'),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context))
                  ]),
          barrierDismissible: false);
      return Future.error('Permissão de localização negada.');
    }
    // ------------------------------------------------------------------------

    Position coordenada = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30));

    setState(() {
      latitude = coordenada.latitude;
      longitude = coordenada.longitude;
    });
  }

  Future baterFoto() async {
    try {
      debugPrint('Imediatamente antes da foto');
      await _controller.setFlashMode(FlashMode.off);
      XFile foto = await _controller.takePicture();
      debugPrint('Foto "batida"');

      await obterLocal();
      obterDataEHora();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NovoRegistro(
                    foto: foto,
                    dataHora: dataHora,
                    latitude: latitude,
                    longitude: longitude,
                  )));
    } on CameraException catch (e) {
      debugPrint('ERRO AO BATER FOTO: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    var _cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);

    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;

        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint('Erro na câmera!\n$e');
    }
  }

  @override
  void initState() {
    super.initState();
    // cameras[0] = traseira
    _controller = CameraController(widget.cameras[1], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      Container(
          child: Row(children: <Widget>[
        FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          onPressed: () {
            debugPrint('Botão bater foto');
            baterFoto();
          },
          child: const Icon(Icons.circle),
        ),
        FloatingActionButton(
            clipBehavior: Clip.antiAlias,
            onPressed: () {
              setState(() =>
                  _cameraTraseiraSelecionada = !_cameraTraseiraSelecionada);
              initCamera(widget.cameras[_cameraTraseiraSelecionada ? 0 : 1]);
            },
            child: const Icon(Icons.flip_camera_android))
      ]))
    ]);
  }
}
