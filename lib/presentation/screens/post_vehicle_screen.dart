import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repository/vehicle_repository.dart';

class PostVehicleScreen extends StatefulWidget {
  const PostVehicleScreen({super.key});

  @override
  _PostVehicleScreenState createState() => _PostVehicleScreenState();
}

class _PostVehicleScreenState extends State<PostVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _electricRangeController = TextEditingController(); // Cambiado a TextEditingController
  final _fuelConsumptionController = TextEditingController(); // Cambiado a TextEditingController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a brand';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(labelText: 'Model'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a model';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _electricRangeController, // Usar controlador de texto
                    decoration: const InputDecoration(labelText: 'Electric Range'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter electric range';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fuelConsumptionController, // Usar controlador de texto
                    decoration: const InputDecoration(labelText: 'Fuel Consumption'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter fuel consumption';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final vehicle = VehicleModel(
                          brand: _brandController.text,
                          model: _modelController.text,
                          electric_range: _electricRangeController.text, // Ahora es un String
                          fuel_consumption: _fuelConsumptionController.text, // Ahora es un String
                        );
                        _postVehicle(context, vehicle);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _postVehicle(BuildContext context, VehicleModel vehicle) async {
    try {
      final vehicleRepository = RepositoryProvider.of<VehicleRepository>(context);

      // Mostrar datos del vehículo para depuración
      print('Posting vehicle: ${vehicle.toJson()}');

      await vehicleRepository.createVehicle(vehicle);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle posted successfully')),
      );

      Navigator.pop(context, true);
    } catch (e, stackTrace) {
      print('Error: $e\nStackTrace: $stackTrace');



      Navigator.pop(context, true);
    }
  }



}
