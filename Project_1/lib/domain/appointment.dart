import 'dart:convert';

enum AppointmentStatus { scheduled, cancelled, completed, rescheduled }

enum Gender { male, female, other }

class Patient {
  int id;
  String name;
  Gender gender;
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

  void bookAppointment(Doctor doctor, DateTime date, String reason) {
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch,
      date: date,
      reason: reason,
      status: AppointmentStatus.scheduled,
      doctor: doctor,
      patient: this,
    );
    appointments.add(appointment);
    doctor.appointments.add(appointment);
  }

  void viewAppointments() {
    if (appointments.isEmpty) {
      print("No appointments found for $name.");
    } else {
      print("Appointments for $name:");
      for (var appointment in appointments) {
        print(
          "With Dr. ${appointment.doctor.name} on ${appointment.date} (${appointment.status})",
        );
      }
    }
  }

  void cancelAppointment(int appointmentId) {
    final appointment = appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception("Appointment not found"),
    );
    if (appointment.status == AppointmentStatus.cancelled) return;
    appointment.cancel();
  }
}

class Appointment {
  int id;
  DateTime date;
  String reason;
  AppointmentStatus status;
  Doctor doctor;
  Patient patient;

  Appointment({
    required this.id,
    required this.date,
    required this.reason,
    required this.status,
    required this.doctor,
    required this.patient,
  });

  void schedule() => status = AppointmentStatus.scheduled;

  void cancel() => status = AppointmentStatus.cancelled;

  void rescheduleAppointment(DateTime newDate, DateTime newTime) {}

  void viewAppointmentDetails() {}
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
      print("No appointments found");
    } else {
      print("Appointments for $name:");
      for (var appointment in appointments) {
        print(
          "Patient: ${appointment.patient.name}, Date: ${appointment.date}, Status: ${appointment.status}",
        );
      }
    }
  }

  void createMeeting(Patient patient, String notes) {
    final meeting = Meeting(
      id: DateTime.now().millisecondsSinceEpoch,
      notes: notes,
    );
  }

  void updateAvailability(String status) {
    print("Dr. $name is now $status");
  }
}

class Meeting {
  int id;
  String notes;

  Meeting({required this.id, required this.notes});

  void addMeetingNotes(String note) {
    notes += "\n- $note";
  }

  void rescheduleMeeting(DateTime newDate, DateTime newTime) {
    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );
    print("Meeting $id rescheduled to $newDateTime");
  }
}
