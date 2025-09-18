class BookingModel {
  final DateTime selectedDate;
  final String selectedTime;
  final String carMake;
  final String carModel;
  final String licensePlate;
  final String carType;
 // final bool isMonthlyBooking;

  BookingModel({
    required this.selectedDate,
    required this.selectedTime,
    required this.carMake,
    required this.carModel,
    required this.licensePlate,
    required this.carType,
    //this.isMonthlyBooking = false,
  });
}
