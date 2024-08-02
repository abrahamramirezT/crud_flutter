import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/vehicle_repository.dart';

class DeleteVehicleScreen extends StatefulWidget {
  const DeleteVehicleScreen({super.key});

  @override
  _DeleteVehicleScreenState createState() => _DeleteVehicleScreenState();
}

class _DeleteVehicleScreenState extends State<DeleteVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Vehicle ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the vehicle ID';
                  }
                  // Validación adicional para asegurar que el ID es un número válido
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      final id = _idController.text;
                      _deleteVehicle(context, id);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid ID format')),
                      );
                    }
                  }
                },
                child: const Text('Delete Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteVehicle(BuildContext context, String id) async {
    try {
      final vehicleRepository = RepositoryProvider.of<VehicleRepository>(context);
      await vehicleRepository.deleteVehicle(id); // Llama al método sin esperar un resultado booleano

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle deleted successfully')),
      );

      // Regresar a la pantalla principal
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete vehicle: $e')),
      );
    }
  }


}
