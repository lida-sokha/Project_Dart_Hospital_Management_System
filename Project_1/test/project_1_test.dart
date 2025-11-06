import 'dart:io';

import 'package:project_1/domain/appointment.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  late Doctor doctorA;
  late Patient patientB;
  late DateTime appointmentDate;

  group('Patient Test', () {
    setUp(() {
      doctorA = Doctor(
        id: 100,
        name: "Dr.smith",
        specialization: "Cardiology",
        contact: "0988909",
      );
      patientB = Patient(
        id: 2,
        name: "Alice",
        gender: Gender.female,
        age: 30,
        contact: "0988766345",
      );
      appointmentDate = DateTime(2026, 1, 15, 10, 0);
    });

    test('bookAppointment adds appointment to patient and Doctor', () {
      patientB.bookAppointment(doctorA, appointmentDate, "Routine Checkup");

      expect(patientB.appointments.length, equals(1));
      expect(doctorA.appointments.length, equals(1));

      final Appointment = patientB.appointments.first;
      expect(Appointment.patient.name, equals("Alice"));
      expect(Appointment.doctor.name, equals("Dr.smith"));
      expect(Appointment.status, equals(AppointmentStatus.scheduled));
    });

    test("cancelAppointment", () {
      patientB.bookAppointment(doctorA, appointmentDate, "Fever");
      final AppointmentId = patientB.appointments.first.id;

      patientB.cancelAppointment(AppointmentId);

      expect(
        patientB.appointments.first.status,
        equals(AppointmentStatus.cancelled),
      );
    });

    test("cancel the appointment that not exit", () {
      final notExistentID = 999;

      expect(
        () => patientB.cancelAppointment(notExistentID),
        throwsA(isA<Exception>()),
      );
    });
  });

  group("Appointment Test", () {
    late Appointment appointment;
    setUp(() {
      doctorA = Doctor(
        id: 101,
        name: "Dr.smith",
        specialization: "Cardiology",
        contact: "0988909",
      );
      patientB = Patient(
        id: 2,
        name: "Alice",
        gender: Gender.female,
        age: 30,
        contact: "0988766345",
      );
      appointmentDate = DateTime(2026, 1, 15, 10, 0);

      appointment = Appointment(
        id: 12345,
        date: appointmentDate,
        reason: 'Initial consultation',
        status: AppointmentStatus.scheduled,
        doctor: doctorA,
        patient: patientB,
      );
    });

    test("change the schedule status", () {
      appointment.status = AppointmentStatus.cancelled;
      appointment.schedule();
      expect(appointment.status, equals(AppointmentStatus.scheduled));
    });

    test("change the status to cancelled", () {
      appointment.cancel();
      expect(appointment.status, equals(AppointmentStatus.cancelled));
    });
    test("complate the appointment", () {
      appointment.complete();
      expect(appointment.status, equals(AppointmentStatus.completed));

    });

    test("rescheduleAppointment", () {
      final newDate = DateTime(2026, 2, 1);
      final newTime = DateTime(2026, 1, 1, 14, 30);

      appointment.rescheduleAppointment(newDate, newTime);
      expect(appointment.status, equals(AppointmentStatus.rescheduled));
      expect(appointment.date.year, equals(2026));
      expect(appointment.date.month, equals(2));
      expect(appointment.date.day, equals(1));
      expect(appointment.date.hour, equals(14));
      expect(appointment.date.minute, equals(30));
    });
  });

  group("Meeting test", () {
    late Meeting meeting;
    late Doctor doctorB;

    setUp(() {
      doctorA = Doctor(
        id: 101,
        name: "Dr.smith",
        specialization: "Cardiology",
        contact: "0988909",
      );
      doctorB = Doctor(
        id: 102,
        name: 'Dr. Jones',
        specialization: 'Neurology',
        contact: '555-0002',
      );
      patientB = Patient(
        id: 1,
        name: 'Alice',
        gender: Gender.female,
        age: 30,
        contact: '555-1234',
      );

      appointmentDate = DateTime(2026, 12, 15, 10, 0);

      meeting = Meeting(
        id: 5678,
        date: appointmentDate,
        reason: 'Multi-disciplinary consult',
        status: AppointmentStatus.scheduled,
        doctor: doctorA,
        patient: patientB,
        participants: [doctorB, doctorA],
        notes: "Initial notes",
      );
    });
    test("AddMeeting Note", () {
      final noteLength = meeting.notes.length;
      meeting.addMeetingNotes("Discuss lab results");

      //Makes sure meeting notes is bigger than it was before.
      expect(meeting.notes.length, greaterThan(noteLength));
      expect(meeting.notes, contains("Discuss lab results"));
    });

    test("rescheduleAppointment", () {
      final oldStatus = meeting.status;
      final newDate = DateTime(2026, 3, 5);
      final newTime = DateTime(2026, 1, 1, 9, 0);

      meeting.rescheduleAppointment(newDate, newTime);

      expect(oldStatus, isNot(AppointmentStatus.rescheduled));
      expect(meeting.status, equals(AppointmentStatus.rescheduled));
      expect(meeting.date.day, equals(5));
      expect(meeting.date.hour, equals(9));
    });

    test("Meeting status changes to completed via 'holdMeeting()'", () {
      // Ensure we start from a non-completed state
      meeting.status = AppointmentStatus.scheduled;
      expect(meeting.status, equals(AppointmentStatus.scheduled));

      // Use the specific method to complete the meeting
      meeting.holdMeeting();

      // The status **SHOULD** now be completed
      expect(meeting.status, equals(AppointmentStatus.completed));
      // Additionally, check for the note added inside holdMeeting()
      expect(meeting.notes, contains("Meeting concluded successfully."));
    });
  });
}
