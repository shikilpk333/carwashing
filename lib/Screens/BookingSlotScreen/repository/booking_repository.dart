import 'package:carwashbooking/Screens/BookingSlotScreen/model/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


/*
  @override
  Future<List<BookingSlot>> getAvailableTimeSlots(DateTime date) async {
    try {
      // Simulate API call - replace with actual Firestore query
      await Future.delayed(const Duration(milliseconds: 500));
      
      // This would be replaced with actual Firestore query
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
  }*/


/*
  @override
  Future<bool> bookSlot(BookingDetails bookingDetails) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // This would be replaced with actual Firestore write operation
      // ignore: unused_local_variable
      final bookingData = {
        'date': Timestamp.fromDate(bookingDetails.date),
        'timeSlot': bookingDetails.timeSlot,
        'carDetails': bookingDetails.carDetails.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // await firestore.collection('bookings').add(bookingData);
      return true;
    } catch (e) {
      throw Exception('Failed to book slot: $e');
    }
  }*/


/*
  @override
  Future<bool> checkSlotAvailability(DateTime date, String timeSlot) async {
    try {
      // Simulate availability check
      await Future.delayed(const Duration(milliseconds: 300));
      return timeSlot != "12:00 PM"; // Example logic
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }*/
}