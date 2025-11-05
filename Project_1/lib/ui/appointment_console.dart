import 'package:project_1/domain/appointment.dart';
import 'dart:io';

void main() {
  Doctor doctor = Doctor(
    id: 1,
    name: "Dr.Ronan",
    specialization: "Cardiology",
    contact: "0123456789",
  );
  Patient patient = Patient(
    id: 1,
    name: "thida",
    gender: Gender.female,
    age: 22,
    contact: "0987654321",
  );
  while (true) {
    print("Hopital Appointment system ");
    print("1. Login as Doctor");
    print("2.Login as Patient");
    print("3. Exit");
    stdout.write("Select role: ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        doctorMenu(doctor, patient);
        break;
      case '2':
        patientMenu(patient, doctor);
        break;
      case '3':
        print("Exiting");
        return;
      default:
        print("Ivalid choice");
    }
  }
}

void patientMenu(Patient patient, Doctor doctor) {
  
}
void doctorMenu(Doctor doctor, Patient patient) {}
