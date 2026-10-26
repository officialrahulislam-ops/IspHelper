import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const WiFiPulseApp());
}

class WiFiPulseApp extends StatelessWidget {
  const WiFiPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Pulse',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6200EE),
        scaffoldBackgroundColor: const Color(0xFF0F1014),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const WiFiDashboard(),
    );
  }
}

class WiFiDashboard extends StatefulWidget {
  const WiFiDashboard({super.key});

  @override
  State<WiFiDashboard> createState() => _WiFiDashboardState();
}

class _WiFiDashboardState extends State<WiFiDashboard> {
  final NetworkInfo _networkInfo = NetworkInfo();
  String _wifiName = 'Unknown';
  String _ipAddress = 'Unknown';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await Permission.location.request();
    _initNetworkInfo();
  }

  Future<void> _initNetworkInfo() async {
    final wifiName = await _networkInfo.getWifiName();
    final ipAddress = await _networkInfo.getWifiIP();
    setState(() {
      _wifiName = wifiName ?? 'Not Connected';
      _ipAddress = ipAddress ?? 'No IP';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('WiFi Pulse', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F26),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.wifi, size: 48, color: Color(0xFF6200EE)),
          const SizedBox(height: 16),
          Text(_wifiName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('IP Address: $_ipAddress', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale();
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildInfoTile('Signal', 'Strong', FontAwesomeIcons.signal),
          _buildInfoTile('Speed', '120 Mbps', FontAwesomeIcons.gaugeHigh),
          _buildInfoTile('Frequency', '5 GHz', FontAwesomeIcons.bolt),
          _buildInfoTile('Security', 'WPA3', FontAwesomeIcons.lock),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: Colors.white70),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
}
