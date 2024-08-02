class VehicleModel {
  final String? id;
  final String brand;
  final String model;
  final String electric_range;
  final String fuel_consumption;

  // Constructor del objeto
  VehicleModel({
    this.id,
    required this.brand,
    required this.model,
    required this.electric_range,
    required this.fuel_consumption,
  });

  // Método para convertir el objeto json a un VehicleModel
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
        id: json['id'].toString(),
        brand: json['brand'].toString(),
        model: json['model'].toString(),
        electric_range: json['electric_range'].toString(),
        fuel_consumption: json['fuel_consumption'].toString(),
    );
  }

  // Método para convertir el objeto a json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'electric_range': electric_range,
      'fuel_consumption': fuel_consumption,
    };
  }
}
