// lib/main.dart (FULL WORKING VERSION)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/trip_provider.dart';
import 'models/trip.dart';
import 'dart:async'; // For Timer

// --- COLOR SCHEME (Unified for the entire app) ---
const Color primaryBackground = Color(0xFF181820); // Dark Gray background
const Color secondaryCard = Color(0xFF28283D);     // Card background
const Color lightTextColor = Color(0xFFF5F5F5);    // Primary text
const Color secondaryTextColor = Color(0xFFD0D0D0); // Subdued text

void main() {
  // Ensure we start the application by providing the TripProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: const CirrusApp(),
    ),
  );
}

// --- Main App Setup ---
class CirrusApp extends StatelessWidget {
  const CirrusApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes to update the theme dynamically
    final dynamicColor = context.watch<TripProvider>().dynamicAccentColor;

    return MaterialApp(
      title: 'Cirrus - The Intelligent Co-Pilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primaryBackground,
        primaryColor: dynamicColor, 
        hintColor: dynamicColor,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.dark(
          primary: dynamicColor,
          secondary: dynamicColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryBackground,
          elevation: 0,
          titleTextStyle: TextStyle(color: lightTextColor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      // Start with the Login Screen
      home: const LoginScreen(), 
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

// --- Login Screen (New Feature) ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicColor = context.watch<TripProvider>().dynamicAccentColor;

    return Scaffold(
      backgroundColor: primaryBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Placeholder for Cirrus Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: dynamicColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cloud_queue, size: 50, color: dynamicColor),
              ),
              const SizedBox(height: 15),
              const Text(
                'CIRRUS Login',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: lightTextColor),
              ),
              const SizedBox(height: 60),

              // Login Button (Smooth Transition)
              ElevatedButton(
                onPressed: () {
                  // Navigate to dashboard with smooth transition
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dynamicColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  'Sign In to Co-Pilot (Demo)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBackground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// --- Dashboard Screen (Core Logic & Adaptive UI) ---

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _clbTimer;
  double simulatedStress = 0.3; // Starting stress level

  @override
  void initState() {
    super.initState();
    // Start the Cognitive Load Balancer (CLB) simulation
    _clbTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      _simulateCognitiveLoad();
    });
  }

  @override
  void dispose() {
    _clbTimer.cancel();
    super.dispose();
  }

  // --- CLB Logic: Simulates real-time stress/flight updates ---
  void _simulateCognitiveLoad() {
    final provider = context.read<TripProvider>(); 
    
    // Logic: Stress increases, then resets on a cycle.
    simulatedStress = (simulatedStress + 0.2).clamp(0.1, 0.8);
    if (simulatedStress > 0.79) {
      simulatedStress = 0.1; // Reset to low stress after peak
    }
    
    // Simulating flight status changes based on stress
    String newStatus = provider.currentTrip.flightStatus;
    if (simulatedStress > 0.6) {
      newStatus = "DELAYED: Gate 4A -> 9B (HIGH STRESS)";
    } else if (simulatedStress < 0.4) {
       newStatus = "On Time (Gate 4A)";
    }

    provider.updateStressAndFlightStatus(
      newStress: simulatedStress,
      newFlightStatus: newStatus,
    );
  }

  // 1. CLB Proactive Alert Widget
  Widget _buildAlertBanner(Trip trip, Color bannerColor) {
    bool isHighStress = trip.stressLevel > 0.6;
    Color statusColor = isHighStress ? const Color(0xFFC62828) : const Color(0xFF3C9A69); // Red/Green
    String message = isHighStress 
      ? 'ATTENTION: High stress detected. Presenting critical data only.'
      : 'Status Stable. Stress Low. Enjoy your personalized recommendations.';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(isHighStress ? Icons.warning : Icons.check_circle_outline, color: statusColor),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: lightTextColor, fontSize: 14))),
        ],
      ),
    );
  }

  // 2. Main Trip Card (UI adapts based on CLB stress level)
  Widget _buildTripCard(BuildContext context, Trip trip, Color dynamicColor) {
    bool isHighStress = trip.stressLevel > 0.6;
    
    // High Stress UI: Minimalist, Critical Focus
    if (isHighStress) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: dynamicColor.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CRITICAL ALERT', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFC62828))),
            const Divider(color: Color(0xFFC62828), height: 20),
            _buildDetailRow(Icons.flight_land, 'Flight Status:', trip.flightStatus, const Color(0xFFC62828)),
            _buildDetailRow(Icons.pin_drop, 'Local Contact:', trip.localContact, const Color(0xFFC62828)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => context.read<TripProvider>().callEmergencyContact(),
                icon: const Icon(Icons.security_sharp, color: Colors.white),
                label: const Text('CALL LOCAL HELP', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
              ),
            )
          ],
        ),
      );
    }

    // Default Low-Stress UI: Detailed, Pleasant
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: secondaryCard, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Journey to ${trip.destination}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: dynamicColor)),
          const Divider(color: secondaryTextColor, height: 20),
          _buildDetailRow(Icons.calendar_today, 'Dates:', trip.dates, dynamicColor),
          _buildDetailRow(Icons.flight, 'Flight Status:', trip.flightStatus, const Color(0xFF3C9A69)),
          _buildDetailRow(Icons.lock, 'Security:', trip.encryptionStatus, const Color(0xFF3C9A69)),
        ],
      ),
    );
  }

  // Helper for detail rows
  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: lightTextColor)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: TextStyle(color: secondaryTextColor))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final trip = tripProvider.currentTrip;
        final dynamicColor = tripProvider.dynamicAccentColor;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('CIRRUS - Intelligent Co-Pilot'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.person, color: dynamicColor),
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
            ),
            actions: [
              // Voucher/Referral Button
              IconButton(
                icon: Icon(Icons.card_giftcard, color: dynamicColor),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Vouchers unlocked! Rewards for data sharing/referral.')),
                   );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Welcome Back!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: lightTextColor)),
                const SizedBox(height: 30),
                
                // 1. CLB Alert Banner
                _buildAlertBanner(trip, dynamicColor),
                
                // 2. Main Trip Card (Adaptive UI)
                _buildTripCard(context, trip, dynamicColor),
                
                const SizedBox(height: 30),
                
                // Recommendations Section
                const Text('Hyper-Personalized Recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: lightTextColor)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: secondaryCard, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'AI Recommendation: Best local coffee near your hotel (98% match).',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ),
                
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
          // 3. AI Capture Button (Core Function)
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              tripProvider.captureNewTrip("New Trip Data"); 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Capturing New Trip Data...')),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Auto-Capture Trip'),
            backgroundColor: dynamicColor,
            foregroundColor: primaryBackground,
          ),
        );
      },
    );
  }
}

// --- Profile Screen (New Feature) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Reusing build methods from the previous chat for consistency
  Widget _buildProfileSection(BuildContext context, {required IconData icon, required String title, required List<Widget> content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: context.watch<TripProvider>().dynamicAccentColor, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: lightTextColor),
            ),
          ],
        ),
        const Divider(color: secondaryTextColor),
        ...content,
      ],
    );
  }

  Widget _buildProfileDetail(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: secondaryTextColor, fontSize: 16)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final dynamicColor = tripProvider.dynamicAccentColor;
        final trip = tripProvider.currentTrip;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('My CIRRUS Profile'),
            backgroundColor: primaryBackground,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: dynamicColor.withOpacity(0.3),
                        child: Icon(Icons.person, size: 60, color: dynamicColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Vishnu (User)', 
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: lightTextColor),
                      ),
                      Text(
                        'Frequent Traveler | Active Co-Pilot', 
                        style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Security Status Section
                _buildProfileSection(
                  context, 
                  icon: Icons.security, 
                  title: 'Data & Security', 
                  content: [
                    _buildProfileDetail(
                      'Encryption Status:', 
                      trip.encryptionStatus, 
                      trip.encryptionStatus.contains('End') ? const Color(0xFF3C9A69) : const Color(0xFFC62828)
                    ),
                    _buildProfileDetail(
                      'Last Stress Reading:', 
                      '${(trip.stressLevel * 100).toStringAsFixed(0)}%', 
                      dynamicColor
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Rewards Section
                _buildProfileSection(
                  context, 
                  icon: Icons.card_giftcard, 
                  title: 'Rewards & Referrals', 
                  content: [
                    _buildProfileDetail('Vouchers Earned:', '3 Vouchers Available', dynamicColor),
                    _buildProfileDetail('Referral Code:', 'CIRRUS123', secondaryTextColor),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                Center(
                   child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dynamicColor.withOpacity(0.2),
                      side: BorderSide(color: dynamicColor),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Return to Dashboard',
                      style: TextStyle(fontSize: 16, color: dynamicColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}