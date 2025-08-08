import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingData {
  final String orderId;
  final LatLng driverLocation;
  final LatLng deliveryAddress;
  final String estimatedTime;
  final String driverName;
  final String driverPhone;
  final String vehicleInfo;

  TrackingData({
    required this.orderId,
    required this.driverLocation,
    required this.deliveryAddress,
    required this.estimatedTime,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleInfo,
  });
}

class TrackingNotifier extends StateNotifier<Map<String, TrackingData>> {
  TrackingNotifier() : super({}) {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    // Données de démonstration pour le tracking
    state = {
      'order1': TrackingData(
        orderId: 'order1',
        driverLocation: const LatLng(6.5244, 3.3792), // Lagos
        deliveryAddress: const LatLng(6.5244, 3.3792), // Même position pour la démo
        estimatedTime: '15-20 minutes',
        driverName: 'Ahmed Diallo',
        driverPhone: '+234 801 234 5678',
        vehicleInfo: 'Toyota Hilux - AB123CD',
      ),
      'order2': TrackingData(
        orderId: 'order2',
        driverLocation: const LatLng(6.5244, 3.3792),
        deliveryAddress: const LatLng(6.5244, 3.3792),
        estimatedTime: '30-45 minutes',
        driverName: 'Fatou Sow',
        driverPhone: '+234 802 345 6789',
        vehicleInfo: 'Suzuki Carry - XY789AB',
      ),
      'order3': TrackingData(
        orderId: 'order3',
        driverLocation: const LatLng(6.5244, 3.3792),
        deliveryAddress: const LatLng(6.5244, 3.3792),
        estimatedTime: '1-2 heures',
        driverName: 'Moussa Keita',
        driverPhone: '+234 803 456 7890',
        vehicleInfo: 'Peugeot Partner - CD456EF',
      ),
    };
  }

  TrackingData? getTrackingData(String orderId) {
    return state[orderId];
  }

  void updateDriverLocation(String orderId, LatLng newLocation) {
    final currentData = state[orderId];
    if (currentData != null) {
      state = {
        ...state,
        orderId: TrackingData(
          orderId: currentData.orderId,
          driverLocation: newLocation,
          deliveryAddress: currentData.deliveryAddress,
          estimatedTime: currentData.estimatedTime,
          driverName: currentData.driverName,
          driverPhone: currentData.driverPhone,
          vehicleInfo: currentData.vehicleInfo,
        ),
      };
    }
  }

  void updateEstimatedTime(String orderId, String newTime) {
    final currentData = state[orderId];
    if (currentData != null) {
      state = {
        ...state,
        orderId: TrackingData(
          orderId: currentData.orderId,
          driverLocation: currentData.driverLocation,
          deliveryAddress: currentData.deliveryAddress,
          estimatedTime: newTime,
          driverName: currentData.driverName,
          driverPhone: currentData.driverPhone,
          vehicleInfo: currentData.vehicleInfo,
        ),
      };
    }
  }
}

final trackingProvider = StateNotifierProvider<TrackingNotifier, Map<String, TrackingData>>((ref) {
  return TrackingNotifier();
}); 