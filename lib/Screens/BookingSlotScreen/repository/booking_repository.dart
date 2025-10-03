import 'package:carwashbooking/Screens/BookingSlotScreen/model/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class BookingRepository {
  Future<List<BookingSlot>> getAvailableTimeSlots(DateTime date);
  Future<bool> bookSlot(BookingDetails bookingDetails);
  Future<bool> checkSlotAvailability(DateTime date, String timeSlot);
}

class FirebaseBookingRepository implements BookingRepository {
  final FirebaseFirestore firestore;

  FirebaseBookingRepository({required this.firestore});

  @override
  Future<List<BookingSlot>> getAvailableTimeSlots(DateTime date) async {
    try {
      // Define all possible slots (you can extend this)
      final allSlots = [
        "09:00 AM",
        "10:00 AM",
        "11:00 AM",
        "12:00 PM",
        "01:00 PM",
        "02:00 PM",
        "03:00 PM",
        "04:00 PM",
        "05:00 PM",
      ];

      // Fetch all bookings for the selected date
      final snapshot = await firestore
          .collection('bookings')
          .where('date',
              isEqualTo: DateUtils.dateOnly(date)) // store only date part
          .get();

      final bookedSlots = snapshot.docs.map((doc) {
        return doc['timeSlot'] as String;
      }).toSet();

      // Build slot list with availability
      return allSlots.map((slot) {
        return BookingSlot(
          time: slot,
          status: bookedSlots.contains(slot) ? "not_available" : "available",
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch time slots: $e');
    }
  }

  @override
  Future<bool> bookSlot(BookingDetails bookingDetails) async {
    try {
      await firestore.collection('bookings').add({
        'date': DateUtils.dateOnly(bookingDetails.date),
        'timeSlot': bookingDetails.timeSlot,
        'carDetails': bookingDetails.carDetails.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to book slot: $e');
    }
  }

  @override
  Future<bool> checkSlotAvailability(DateTime date, String timeSlot) async {
    try {
      final query = await firestore
          .collection('bookings')
          .where('date', isEqualTo: DateUtils.dateOnly(date))
          .where('timeSlot', isEqualTo: timeSlot)
          .get();

      return query.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }
}



/*
class FirebaseBookingRepository implements BookingRepository {
  final FirebaseFirestore firestore;

  FirebaseBookingRepository({required this.firestore});

  @override
  Future<List<BookingSlot>> getAvailableTimeSlots(DateTime date) async {
    try {
      // Simulate API call - replace with actual Firestore query
      await Future.delayed(const Duration(milliseconds: 500));

      // Example static slots (replace with real Firestore fetch if needed)
      final availableSlots = [
        BookingSlot(time: "09:00 AM", status: "available"),
        BookingSlot(time: "10:00 AM", status: "available"),
        BookingSlot(time: "11:00 AM", status: "available"),
        BookingSlot(time: "12:00 PM", status: "not_available"),
      ];

      return availableSlots;
    } catch (e) {
      throw Exception('Failed to fetch time slots: $e');
    }
  }

 @override
  Future<bool> bookSlot(BookingDetails bookingDetails) async {
    try {
      final bookingData = {
        'date': Timestamp.fromDate(bookingDetails.date),   // booking date
        'timeSlot': bookingDetails.timeSlot,              // selected slot
        'carDetails': bookingDetails.carDetails.toMap(),  // car details
        'createdAt': FieldValue.serverTimestamp(),        // created timestamp
      };

      await firestore.collection('bookings').add(bookingData);

      return true;
    } catch (e) {
      throw Exception('Failed to book slot: $e');
    }
  }

 @override
  Future<bool> checkSlotAvailability(DateTime date, String timeSlot) async {
    try {
      // 🔹 Check if any booking already exists for the same date & slot
      final query = await firestore
          .collection('bookings')
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('timeSlot', isEqualTo: timeSlot)
          .get();

      return query.docs.isEmpty; // true if no booking found
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }

}*/