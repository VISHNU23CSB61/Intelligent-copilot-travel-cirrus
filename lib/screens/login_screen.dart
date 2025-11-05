// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/trip_provider.dart';
import '../theme.dart';

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
                  color: dynamicColor.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cloud_queue, size: 50, color: dynamicColor),
              ),
              const SizedBox(height: 15),
              const Text(
                'CIRRUS Login',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: lightTextColor),
              ),
              const SizedBox(height: 40),

              // Username Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username or Email',
                  labelStyle: const TextStyle(color: secondaryTextColor),
                  prefixIcon: Icon(Icons.person, color: dynamicColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: secondaryCard, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dynamicColor, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: lightTextColor),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: secondaryTextColor),
                  prefixIcon: Icon(Icons.lock, color: dynamicColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: secondaryCard, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dynamicColor, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: lightTextColor),
              ),
              const SizedBox(height: 40),

              // Login Button (Smooth Transition)
              ElevatedButton(
                onPressed: () {
                  // Navigate to dashboard with a smooth transition
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dynamicColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  'Sign In to Co-Pilot',
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
