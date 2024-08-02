import 'package:equatable/equatable.dart';
import '../../data/models/vehicle_model.dart'; // Asegúrate de que el modelo se llame VehicleModel y esté en esta ruta

abstract class VehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleSuccess extends VehicleState {
  final List<VehicleModel> vehicles;

  VehicleSuccess({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehicleError extends VehicleState {
  final String message;

  VehicleError({required this.message});

  @override
  List<Object?> get props => [message];
}
