import 'dart:convert';
import 'dart:typed_data';

class Registro {
  /// Model dos registros. Instanciar apenas via construtor fromJson
  final int id;
  final String data;
  final String hora;
  final double latitude;
  final double longitude;
  final Uint8List fotoBytes;
  final String? motivo;

  Registro(
      {required this.id,
      required this.data,
      required this.hora,
      required this.latitude,
      required this.longitude,
      required this.fotoBytes,
      this.motivo});

  factory Registro.fromJson(Map<String, dynamic> json) {
    var aux = DateTime.parse(json['data_hora']);
    return Registro(
        id: json['id'],
        data:
            '${aux.day.toString().padLeft(2, '0')}/${aux.month.toString().padLeft(2, '0')}/${aux.year}',
        hora:
            '${aux.hour.toString().padLeft(2, '0')}:${aux.minute.toString().padLeft(2, '0')}',
        latitude: json['latitude'],
        longitude: json['longitude'],
        fotoBytes: base64.decode(json['foto']),
        motivo: json['motivo']);
  }

  @override
  String toString() {
    return 'id: $id, data: $data, hora: $hora, latitude: $latitude, longitude: $longitude, fotoBytes: $fotoBytes, motivo: $motivo';
  }
}
