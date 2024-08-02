import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app_novenoa/data/repository/vehicle_repository.dart';
import 'package:my_app_novenoa/presentation/screens/post_vehicle_screen.dart';
import '../cubit/vehicle_cubit.dart';
import '../cubit/vehicle_state.dart';
import 'delete_vehicle_screen.dart';
import 'get_one_vehicle_screen.dart';
import '../../data/models/vehicle_model.dart';
import 'put_vehicle_screen.dart';

class VehicleListView extends StatelessWidget {
  const VehicleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
      ),
      body: BlocProvider(
        create: (context) => VehicleCubit(
          vehicleRepository: RepositoryProvider.of<VehicleRepository>(context),
        ),
        child: const VehicleListScreen(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostVehicleScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeleteVehicleScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListOneVehicleScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleCubit = BlocProvider.of<VehicleCubit>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            vehicleCubit.fetchAllVehicles();
          },
          child: const Text('Fetch Vehicles'),
        ),
        Expanded(
          child: BlocBuilder<VehicleCubit, VehicleState>(
            builder: (context, state) {
              if (state is VehicleLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VehicleSuccess) {
                final vehicles = state.vehicles;
                return ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return ListTile(
                      title: Text(vehicle.brand),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Id: ${vehicle.id}'),
                          Text('Model: ${vehicle.model}'),
                          Text('Electric Range: ${vehicle.electric_range}'),
                          Text('Fuel Consumption: ${vehicle.fuel_consumption}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PutVehicleScreen(vehicle: vehicle),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is VehicleError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Press the button to fetch vehicles'));
            },
          ),
        ),
      ],
    );
  }
}
