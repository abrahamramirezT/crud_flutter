import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repository/vehicle_repository.dart';

class PutVehicleScreen extends StatefulWidget {
  final VehicleModel vehicle; // Recibe el vehículo que se desea actualizar

  const PutVehicleScreen({super.key, required this.vehicle});

  @override
  _PutVehicleScreenState createState() => _PutVehicleScreenState();
}

class _PutVehicleScreenState extends State<PutVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _electricRangeController;
  late TextEditingController _fuelConsumptionController;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.vehicle.brand);
    _modelController = TextEditingController(text: widget.vehicle.model);
    _electricRangeController = TextEditingController(text: widget.vehicle.electric_range);
    _fuelConsumptionController = TextEditingController(text: widget.vehicle.fuel_consumption);
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _electricRangeController.dispose();
    _fuelConsumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Vehicle'),
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
                        final updatedVehicle = VehicleModel(
                          id: widget.vehicle.id, // Mantener el ID original
                          brand: _brandController.text,
                          model: _modelController.text,
                          electric_range: _electricRangeController.text, // Parsear a double
                          fuel_consumption: _fuelConsumptionController.text, // Parsear a double
                        );
                        _updateVehicle(context, updatedVehicle);
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateVehicle(BuildContext context, VehicleModel vehicle) async {
    try {
      final vehicleRepository = RepositoryProvider.of<VehicleRepository>(context);
      await vehicleRepository.updateVehicle(vehicle); // Método para actualizar el vehículo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle updated successfully')),
      );
      Navigator.pop(context, true); // Volver a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update vehicle: $e')),
      );
    }
  }
}
