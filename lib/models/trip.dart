// lib/models/trip.dart

class Trip {
  final String id;
  final String destination;
  final String dates;
  final String flightStatus; // Real-time status
  final double stressLevel; // For CLB feature (0.0 to 1.0)
  final String encryptionStatus; // Security feature
  final String localContact; // Local emergency contact

  Trip({
    required this.id,
    required this.destination,
    required this.dates,
    this.flightStatus = 'Status Loading...',
    this.stressLevel = 0.5,
    this.encryptionStatus = 'End-to-End Encrypted',
    this.localContact = 'Police, Ambulance, Local Helpline',
  });
}