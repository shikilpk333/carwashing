import 'package:carwashbooking/Screens/BookingConfirmation/model/booking_model.dart';

abstract class BookingRepository {
  Future<void> cancelBooking(BookingModel booking);
}

class BookingRepositoryImpl implements BookingRepository {
  @override
  Future<void> cancelBooking(BookingModel booking) async {
    // Here you can handle Firebase/Firestore/REST API call
    await Future.delayed(const Duration(seconds: 1)); 
    print("Booking cancelled: ${booking.licensePlate}");
  }
}
