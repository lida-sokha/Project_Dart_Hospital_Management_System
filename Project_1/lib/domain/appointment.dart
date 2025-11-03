import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Patient {
  int id;
  String name;
  String gender;
  int age;
  String contact;
  List<Appointment> appointments = [];

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.contact,
  });

  void bookAppointment(Doctor doctor, DateTime date, String reason) {}

  void viewAppointents() {
    if (appointments.isEmpty) {
      print("no appointment found for $name.");
    } else {
      print("Appointment for $name:");
      for (var a in appointments) {
        print("with doctor ID ${a.doctorID} on ${a.date} (${a.status})");
      }
    }
  }
}

class Appointment {
  int id;
  DateTime date;
  String reason;
  String status;
  int doctorID;
  int patientID;

  Appointment({
    required this.id,
    required this.date,
    required this.reason,
    required this.status,
    required this.doctorID,
    required this.patientID,
  });
  void schedule() => status = "Scheduled";

  void cancel() => status = "Cancelled";
}

class Doctor {
  int id;
  String name;
  String specialization;
  String contact;
  List<Appointment> appointments = [];

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.contact,
  });
  void viewAppointments() {
    if (appointments.isEmpty) {
      print("Not fount appointment");
    } else {
      print("Appoint for $name");
      for (var d in appointments) {
        print("PatientId: ${d.patientID}, date:${d.date}, status: ${d.status}");
      }
    }
  }

  void createMeeting() {}
}
