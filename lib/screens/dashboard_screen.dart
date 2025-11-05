// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/trip_provider.dart';
import '../theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                        backgroundColor: dynamicColor.withAlpha(77),
                        child: Icon(Icons.person, size: 60, color: dynamicColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Vishnu', 
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: lightTextColor),
                      ),
                      const Text(
                        'Frequent Traveler | ec2-user', // Just for fun reference
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
                      trip.encryptionStatus == 'End-to-End Encrypted' ? successColor : dangerColor
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
              ],
            ),
          ),
        );
      },
    );
  }

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
}