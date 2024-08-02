import 'package:bloc/bloc.dart';
import '../../data/models/vehicle_model.dart'; // Asegúrate de que el modelo se llame VehicleModel y esté en esta ruta
import '../../data/repository/vehicle_repository.dart'; // Actualiza la ruta si es necesario
import 'vehicle_state.dart'; // Asegúrate de que el estado se llame VehicleState y esté en esta ruta

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleCubit({required this.vehicleRepository}) : super(VehicleInitial());

  Future<void> createVehicle(VehicleModel vehicle) async {
    try {
      emit(VehicleLoading());
      await vehicleRepository.createVehicle(vehicle);
      fetchAllVehicles();
      final vehicles = await vehicleRepository.getAllVehicles();
      emit(VehicleSuccess(vehicles: vehicles));
    } catch (e) {
      emit(VehicleError(message: e.toString()));
    }
  }

  Future<void> getVehicle(String id) async {
    try {
      emit(VehicleLoading());
      final vehicle = await vehicleRepository.getVehicle(id);
      emit(VehicleSuccess(vehicles: [vehicle]));
    } catch (e) {
      emit(VehicleError(message: e.toString()));
    }
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
      emit(VehicleLoading());
      await vehicleRepository.updateVehicle(vehicle);
      fetchAllVehicles();
      final vehicles = await vehicleRepository.getAllVehicles();
      emit(VehicleSuccess(vehicles: vehicles));
    } catch (e) {
      emit(VehicleError(message: e.toString()));
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      emit(VehicleLoading());
      await vehicleRepository.deleteVehicle(id);
      fetchAllVehicles();
      final vehicles = await vehicleRepository.getAllVehicles();
      emit(VehicleSuccess(vehicles: vehicles));
    } catch (e) {
      emit(VehicleError(message: e.toString()));
    }
  }

  Future<void> fetchAllVehicles() async {
    try {
      emit(VehicleLoading());
      final vehicles = await vehicleRepository.getAllVehicles();
      emit(VehicleSuccess(vehicles: vehicles));
    } catch (e) {
      emit(VehicleError(message: e.toString()));
    }
  }
}
