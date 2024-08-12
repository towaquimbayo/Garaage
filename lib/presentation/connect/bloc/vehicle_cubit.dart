import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleCubit extends Cubit<Map<String, dynamic>?> {
  VehicleCubit() : super(null);

  void addSampleVehicle() {
    emit({
      'vin': '1NXBR32E85Z505904',
      'status': 'Connected',
      'name': 'Toyota Prius',
      'description': '2005 Base',
      'transmission': 'Auto',
      'numSeats': 5,
      'errors': 2,
      'fuelConsumed': 70,
      'totalFuel': 100,
      'speed': 68,
      'rpm': 2731,
      'battery': 83,
      'oil': 59,
      'coolantCurrent': 90,
      'coolantDesired': 120,
    });
  }

  void clearVehicle() {
    emit(null);
  }
}