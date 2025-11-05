// lib/state/trip_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripProvider with ChangeNotifier {
  // --- Simulating Core Trip Data ---
  Trip _currentTrip = Trip(
    id: 'T001',
    destination: 'Paris, France',
    dates: 'Nov 12 - Nov 19',
    flightStatus: 'On Time (Gate 4A)',
    stressLevel: 0.3, // Low stress initially
    encryptionStatus: 'End-to-End Encrypted',
  );

  Trip get currentTrip => _currentTrip;

  // --- Dynamic Color Logic ---
  // Lite Purple/Lavender for calm, Red for danger
  Color get dynamicAccentColor {
    if (_currentTrip.stressLevel > 0.6) {
      return const Color(0xFFC62828); // Darker Red for high stress
    } else {
      return const Color(0xFFC3A3D5); // Soft Lavender/Lite Purple for calm
    }
  }

  // --- AI Capture/Data Ingestion ---
  void captureNewTrip(String data) {
    // Simulates calling the backend NLP service and receiving a new trip object
    _currentTrip = Trip(
      id: 'T002',
      destination: 'Singapore, SG (NEW TRIP)',
      dates: 'Dec 1 - Dec 5',
      flightStatus: 'Analyzing Data...',
      stressLevel: 0.9, // New trip usually means high initial stress/activity
      encryptionStatus: 'Processing Encryption...',
    );
    notifyListeners();
  }

  // --- Real-Time Cognitive Load Balancer (CLB) Update ---
  void updateStressAndFlightStatus({double? newStress, String? newFlightStatus}) {
    _currentTrip = Trip(
      id: _currentTrip.id,
      destination: _currentTrip.destination,
      dates: _currentTrip.dates,
      flightStatus: newFlightStatus ?? _currentTrip.flightStatus,
      stressLevel: newStress ?? _currentTrip.stressLevel,
      encryptionStatus: _currentTrip.encryptionStatus,
    );
    notifyListeners();
  }

  // --- Local Emergency Contact ---
  void callEmergencyContact() {
    // In a real app, this would initiate a local phone call based on geo-location
    print('ACTION: Initiating contact for local emergency support in ${_currentTrip.destination}');
  }
}