import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      'image': '',
      'errorCodes': [
        'P0128',
        'P0420',
      ],
    });
  }

  Future<void> fetchVehicleData(String userId) async {
    QuerySnapshot userVehicles = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Vehicles')
        .get();
    final userVehiclesData = userVehicles.docs.map((e) => e.data()).toList();

    if (userVehiclesData.isNotEmpty) {
      final vehicleData = userVehiclesData[0] as Map<String, dynamic>;

      final cars = FirebaseStorage.instance.ref().child('cars');
      final ref = cars.child('toyota').child('prius').child('2005').child('toyota-prius-2005-hybrid_hb-millennium_silver_metallic.png');
      final networkImageURL = await ref.getDownloadURL();
      
      vehicleData['image'] = networkImageURL;

      emit(vehicleData);
    }
  }

  void clearVehicle() {
    emit(null);
  }
}