class BookingSlot {
  final String time;
  final String status;

  BookingSlot({required this.time, required this.status});

  factory BookingSlot.fromMap(Map<String, dynamic> map) {
    return BookingSlot(
      time: map['time'] ?? '',
      status: map['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'status': status,
    };
  }
}

class CarDetails {
  final String make;
  final String model;
  final String licensePlate;
  final String type;

  CarDetails({
    required this.make,
    required this.model,
    required this.licensePlate,
    required this.type,
  });

  factory CarDetails.fromMap(Map<String, dynamic> map) {
    return CarDetails(
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      licensePlate: map['licensePlate'] ?? '',
      type: map['type'] ?? 'Sedan',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'make': make,
      'model': model,
      'licensePlate': licensePlate,
      'type': type,
    };
  }
}

class BookingDetails {
  final DateTime date;
  final String timeSlot;
  final CarDetails carDetails;

  BookingDetails({
    required this.date,
    required this.timeSlot,
    required this.carDetails,
  });

  bool get isValid => 
      // ignore: unnecessary_null_comparison
      date != null && 
      timeSlot.isNotEmpty && 
      carDetails.make.isNotEmpty && 
      carDetails.model.isNotEmpty && 
      carDetails.licensePlate.isNotEmpty;
}