import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle_model.dart'; // Asegúrate de que el modelo se llame VehicleModel y esté en esta ruta

class VehicleRepository {
  final String apiUrl;

  VehicleRepository({required this.apiUrl});

  Future<void> createVehicle(VehicleModel vehicle) async {
    final response = await http.post(
      Uri.parse('$apiUrl/create_coche_hibrido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(vehicle.toJson()..remove('id')), // Exclude 'id' for creation
    );

    if (response.statusCode == 201) {
      // La creación fue exitosa
      print('Vehicle created successfully');
    } else {
      // Agregar información detallada en el mensaje de error
      final responseBody = response.body.isNotEmpty
          ? response.body
          : 'No additional information available';
      throw Exception('Failed to create vehicle: ${response.statusCode} - $responseBody');
    }
  }


  Future<VehicleModel> getVehicle(String id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/read_one_coche_hibrido/ 3$id'),
    );

    if (response.statusCode == 200) {
      return VehicleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load vehicle');
    }
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update_coche_hibrido/${vehicle.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update vehicle');
    }
  }

  Future<void> deleteVehicle(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete_coche_hibrido/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete vehicle');
    }
  }

  Future<List<VehicleModel>> getAllVehicles() async {
    final response = await http.get(
      Uri.parse('$apiUrl/read_all_coche_hibrido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<VehicleModel>.from(l.map((model) => VehicleModel.fromJson(model)));
    } else {
      throw Exception('Failed to load users');
    }
  }

}
