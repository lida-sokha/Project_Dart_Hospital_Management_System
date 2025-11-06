import 'dart:io';
import 'dart:convert';
import '../domain/appointment.dart';

class AppointmentFileProvider {
  final String filePath = '../data/appointments.json'; 
  
  Future<void> _ensureDirectoryExists(String path) async {
    final parentDir = Directory(path); 
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
      print('Created directory: ${parentDir.path}');
    }
  }

  Future<void> saveAppointments(List<Appointment> appointments) async {
    final directoryPath = '../data';
    
    await _ensureDirectoryExists(directoryPath); 
    
    final file = File(filePath);
    final jsonData = appointments.map((a) => a.toJson()).toList();
    
    await file.writeAsString(jsonEncode(jsonData));
    
    print('Appointments saved to ${file.absolute.path}'); 
  }

  Future<List<Appointment>> loadAppointments() async {
    final file = File(filePath);
    
    if (!await file.exists()) {
      print('No saved appointments found.');
      return [];
    }

    try {
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      print('Error reading/decoding appointments file: $e');
      return [];
    }
  }
}