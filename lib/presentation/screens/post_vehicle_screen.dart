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
  final _electricRangeController = TextEditingController();
  final _fuelConsumptionController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simular generación automática de ID. Deja esto vacío ya que el ID se genera automáticamente en el backend.
    _idController.text = 'ID Automatico';
  }

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
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      hintText: 'ID AUTOMATICO',
                    ),
                    readOnly: true, // El campo es solo lectura.
                  ),
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
                    controller: _electricRangeController,
                    decoration: const InputDecoration(labelText: 'Electric Range'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter electric range';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fuelConsumptionController,
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
                          // El ID se debería manejar en el backend, así que no lo establecemos aquí.
                          id: null,
                          brand: _brandController.text,
                          model: _modelController.text,
                          electric_range: _electricRangeController.text,
                          fuel_consumption: _fuelConsumptionController.text,
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

      print('Posting vehicle: ${vehicle.toJson()}');

      await vehicleRepository.createVehicle(vehicle);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle posted successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      // Mostrar información detallada del error en el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e.toString()}')),
      );

      Navigator.pop(context, false);
    }
  }
}
