import 'dart:ffi';

import '../data/appointment_file_provider.dart';
import 'package:project_1/domain/appointment.dart';
import 'dart:io';

void main() async {
  final fileProvider = AppointmentFileProvider();
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

  Appointment appointment = Appointment(
    id: 1,
    date: DateTime.now(),
    reason: 'placeholder',
    status: AppointmentStatus.scheduled,
    doctor: doctor,
    patient: patient,
  );
  Meeting meeting = Meeting(
    id: 1,
    date: DateTime.now(),
    reason: 'placeholder meeting',
    status: AppointmentStatus.scheduled,
    doctor: doctor,
    patient: patient,
  );
  while (true) {
    print("Hopital Appointment system ");
    print("1. Login as Doctor");
    print("2. Login as Patient");
    print("3. Exit");
    stdout.write("Select role: ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        doctorMenu(doctor, patient, appointment, meeting, fileProvider);
        break;
      case '2':
        patientMenu(patient, doctor, fileProvider);
        break;
      case '3':
        print("Exiting");
        await fileProvider.saveAppointments([...doctor.appointments]);
        return;
      default:
        print("Ivalid choice");
    }
  }
}

void patientMenu(
  Patient patient,
  Doctor doctor,
  AppointmentFileProvider fileProvider,
) {
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

          print("Appointment booked successfully on $appointmentDate!");

          patient.bookAppointment(doctor, appointmentDate, reason);

          // Save all appointments to file
          fileProvider.saveAppointments(doctor.appointments);
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
            doctor.appointments
                .removeWhere((a) => a.id == appointmentId);
            print("Appointment cancelled successfully!");

            fileProvider.saveAppointments(doctor.appointments);
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

String promptString(String prompt) {
  stdout.write(prompt);
  String? input = stdin.readLineSync();
  return input ?? '';
}

DateTime promptDateTime(String prompt) {
  while (true) {
    String dateStr = promptString(prompt);
    try {
      // Simple format: YYYY-MM-DD HH:MM
      // Example: 2025-12-31 14:30
      List<String> parts = dateStr.split(' ');
      if (parts.length != 2)
        throw FormatException("Invalid format. Use YYYY-MM-DD HH:MM");

      List<int> date = parts[0]
          .split('-')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();
      List<int> time = parts[1]
          .split(':')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();

      if (date.length != 3 || time.length != 2)
        throw FormatException("Invalid date or time component.");

      return DateTime(date[0], date[1], date[2], time[0], time[1]);
    } catch (e) {
      print(
        "Invalid date/time format. Please use YYYY-MM-DD HH:MM (e.g., 2025-12-31 14:30)",
      );
    }
  }
}

void doctorMenu(
  Doctor doctor,
  Patient patient,
  Appointment appointment,
  Meeting meeting,
  AppointmentFileProvider fileProvider,
) {
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
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print("View Appointments:");
        doctor.viewAppointments();
        break;
      case '2':
        if (doctor.appointments.isEmpty) {
          print("No appointments");
          break;
        }
        doctor.viewAppointments();
        final idStr = promptString("Enter Appointment ID to view details: ");
        final id = int.tryParse(idStr);
        if (id == null) {
          print("Invalid ID format.");
          break;
        }
        final appointment = doctor.appointments.firstWhere(
          (a) => a.id == id,
          orElse: () => throw Exception("Appointment not found."),
        );
        print("\n--- Appointment Details ---");
        appointment.viewAppointmentDetails();
        break;
      case '3':
        if (doctor.appointments.isEmpty) {
          print("No appointment to cancel");
          break;
        }
        doctor.viewAppointments();
        final idStr = promptString("Enter Appointment ID to cancel: ");
        final id = int.tryParse(idStr);
        if (id == null) {
          print("Invalid ID format.");
          break;
        }
        // Since the appointment is linked to the Patient use the patient's method.
        final appointmentToCancel = doctor.appointments.firstWhere(
          (a) => a.id == id,
          orElse: () => throw Exception("Appointment not found."),
        );
        appointmentToCancel.patient.cancelAppointment(id);
        print("Appointment $id successfully cancelled.");
        fileProvider.saveAppointments(doctor.appointments);
        break;

      case '4':
        print("Update the Availability");
        final newstatus = promptString("Enter your new status");
        doctor.updateAvailability(newstatus.trim());
        break;
      case '5':
        print("Create Meeting");
        final mockPatient = Patient(
          id: 1000,
          name: "Alex",
          gender: Gender.male,
          age: 40,
          contact: "098789987",
        );
        final date = promptDateTime(
          "Enter Meeting Date and Time (YYYY-MM-DD HH:MM):",
        );
        final reason = promptString("Enter meeting Reason:");
        final notes = promptString("Enter Initial meeting notes:");

        doctor.createMeeting(mockPatient, date, reason, notes);
        final newMeetingId = doctor.appointments.last.id;

        print(
          "Meeting scheduled successfully! Patient: ${mockPatient.name}, ID is: $newMeetingId",
        );
        fileProvider.saveAppointments(doctor.appointments);
        break;
      case '6':
        final meeting = doctor.appointments.whereType<Meeting>().toSet();
        if (meeting.isEmpty) {
          print("No meeting found to add notes");
          break;
        }
        print("Select meeting to add notes");
        for (var m in meeting) {
          print("ID: ${m.id} Patients: ${m.patient.name}, Date: ${m.date}");
        }
        final idStr = promptString("Enter meeting ID:");
        final id = int.tryParse(idStr);
        if (id == null) {
          print("Invalid ID format");
          break;
        }
        final targetMeeting = meeting.firstWhere(
          (m) => m.id == id,
          orElse: () => throw Exception("Meeting not found."),
        );
        final note = promptString("Enter note to add:");
        targetMeeting.addMeetingNotes(note);
        print("Note added to Meeting ID $id.");
        fileProvider.saveAppointments(doctor.appointments);
        break;
      case '0':
        print("Returning to Main Menu.");
        return;
      default:
        print("Invalid input");
        break;
    }
  }
}
