// another_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repository/vehicle_repository.dart';

class ListOneVehicleScreen extends StatefulWidget {
  const ListOneVehicleScreen({super.key});

  @override
  _ListOneVehicleScreenState createState() => _ListOneVehicleScreenState();
}

class _ListOneVehicleScreenState extends State<ListOneVehicleScreen> {
  final _idController = TextEditingController();
  VehicleModel? _vehicle;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get One Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Enter Vehicle ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final id = _idController.text;
                if (id.isNotEmpty) {
                  try {
                    final vehicleRepository = RepositoryProvider.of<VehicleRepository>(context);
                    final vehicle = await vehicleRepository.getVehicle(id);
                    setState(() {
                      _vehicle = vehicle;
                      _errorMessage = '';
                    });
                  } catch (e) {
                    setState(() {
                      _vehicle = null;
                      _errorMessage = 'Failed to load vehicle: ${e.toString()}';
                    });
                  }
                }
              },
              child: const Text('Get Vehicle'),
            ),
            const SizedBox(height: 20),
            if (_vehicle != null) ...[
              Text('Brand: ${_vehicle!.brand}'),
              Text('Model: ${_vehicle!.model}'),
              Text('Electric Range: ${_vehicle!.electric_range}'),
              Text('Fuel Consumption: ${_vehicle!.fuel_consumption}'),
            ] else if (_errorMessage.isNotEmpty) ...[
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
