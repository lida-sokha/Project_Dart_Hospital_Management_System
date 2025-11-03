import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Patient {
  int id;
  String name;
  String gender;
  int age;
  String contact;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.contact,
  });

  void bookAppointment() {}

  void viewAppointents() {}
}

class Appointment {
  int id;
  Date date;
  Time time;
  String reason;
  String status;
  List<Doctor> doctorID;
  List<Patient> patientID;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.doctorID,
    required this.patientID,
  });
  void schedule() {}

  void cancel() {}
}

class Doctor {
  int id;
  String name;
  String specialization;
  String contact;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.contact,
  });
  void viewAppointments() {}

  void createMeeting() {}
}
