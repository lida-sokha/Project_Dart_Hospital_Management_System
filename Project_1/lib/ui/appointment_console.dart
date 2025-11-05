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
  while (true) {
    print("\n=== Patient Menu ===");
    print("1. Book Appointment");
    print("2. View Appointments");
    print("3. Cancel Appointment");
    print("0. Back");
    stdout.write("Select an option: ");
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print("\n--- Book Appointment ---");
        print(
          "Available Doctor: Dr. ${doctor.name} (${doctor.specialization})",
        );

        stdout.write("Enter appointment date (YYYY-MM-DD): ");
        final dateInput = stdin.readLineSync();
        stdout.write("Enter appointment time (HH:MM): ");
        final timeInput = stdin.readLineSync();
        stdout.write("Enter reason for appointment: ");
        final reason = stdin.readLineSync() ?? '';

        try {
          final dateParts = dateInput!.split('-').map(int.parse).toList();
          final timeParts = timeInput!.split(':').map(int.parse).toList();

          final appointmentDate = DateTime(
            dateParts[0],
            dateParts[1],
            dateParts[2],
            timeParts[0],
            timeParts[1],
          );

          patient.bookAppointment(doctor, appointmentDate, reason);
          print("Appointment booked successfully on $appointmentDate!");
        } catch (e) {
          print("Invalid date or time format. Please try again.");
        }
        break;

      case '2':
        print("\n--- View Appointments ---");
        patient.viewAppointments();
        break;

      case '3':
        print("\n--- Cancel Appointment ---");
        if (patient.appointments.isEmpty) {
          print("No appointments to cancel.");
          break;
        }

        print("Your Appointments:");
        for (var app in patient.appointments) {
          print(
            "ID: ${app.id}, Date: ${app.date}, Doctor: ${app.doctor.name}, Status: ${app.status}",
          );
        }

        stdout.write("Enter appointment ID to cancel: ");
        final appointmentId = int.tryParse(stdin.readLineSync() ?? '');
        if (appointmentId != null) {
          try {
            patient.cancelAppointment(appointmentId);
            print("Appointment cancelled successfully!");
          } catch (e) {
            print(e);
          }
        } else {
          print("Invalid appointment ID.");
        }
        break;

      case '0':
        print("Returning to main menu...");
        return;

      default:
        print("Invalid option. Try again.");
    }
  }
}

void doctorMenu(Doctor doctor, Patient patient) {
  while (true) {
    print("\n=== Doctor Menu ===");
    print("1. View Appointments");
    print("2. View Appointment Details");
    print("3. Cancel Appointment");
    print("4. Update Availability");
    print("5. Create Meeting");
    print("6. Add Meeting Note");
    print("0. Back to Main Menu");
    stdout.write("Select an option: ");
    stdin.readLineSync();
  }
}
