import 'package:carwashbooking/Screens/BookingConfirmation.dart';
import 'package:flutter/material.dart';

class SlotBookingScreen extends StatefulWidget {
  const SlotBookingScreen({super.key});

  @override
  State<SlotBookingScreen> createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime; //= "10:00 AM";

  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();

  String carType = "Sedan";
  final List<Map<String, String>> timeSlots = [
    {"time": "09:00 AM", "status": "available"},
    {"time": "10:00 AM", "status": "selected"},
    {"time": "11:00 AM", "status": "available"},
    {"time": "12:00 PM", "status": "not_available"},
  ];

  //final List<String> timeSlots = ["09:00 AM", "10:00 AM", "11:00 AM"];

DateTime getInitialDate() {
  DateTime today = DateTime.now();
  // If today is Sunday, skip to Monday
  if (today.weekday == DateTime.sunday) {
    today = today.add(const Duration(days: 1));
  }
  return today;
}

DateTime getNextAvailableDate(DateTime from) {
  DateTime nextDay = from.add(const Duration(days: 1));
  // If next day is Sunday, skip to Monday
  if (nextDay.weekday == DateTime.sunday) {
    nextDay = nextDay.add(const Duration(days: 1));
  }
  return nextDay;
}

_selectDate(BuildContext context) async {
  DateTime today = getInitialDate();
  DateTime tomorrow = getNextAvailableDate(today);

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: today,
    lastDate: tomorrow,
  );

  if (picked != null) {
    setState(() {
      selectedDate = picked;
    });
  }
}


/*

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }*/

  @override
  void initState() {
    super.initState();
    final defaultSlot = timeSlots.firstWhere(
      (slot) => slot["status"] == "selected",
      orElse: () => timeSlots.first,
    );
    selectedTime = defaultSlot["time"];

    // Optional: clear the status of all slots after initializing
    for (var slot in timeSlots) {
      if (slot["status"] == "selected") slot["status"] = "available";
    }
  }


  DateTime previousAvailableDate(DateTime from) {
  DateTime prev = from.subtract(const Duration(days: 1));
  if (prev.weekday == DateTime.sunday) {
    prev = prev.subtract(const Duration(days: 1));
  }
  return prev;
}

DateTime nextAvailableDate(DateTime from) {
  DateTime next = from.add(const Duration(days: 1));
  if (next.weekday == DateTime.sunday) {
    next = next.add(const Duration(days: 1));
  }
  return next;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Booking Slot",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---- Date Row ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, size: 20),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                            selectedDate = getInitialDate();
                       // selectedDate = selectedDate.subtract(
                         // const Duration(days: 1),
                       // );
                      });
                    },
                  ),
                  Text(
                    "${selectedDate.day} ${_monthName(selectedDate.month)}, ${selectedDate.year}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                          DateTime today = getInitialDate();
                         selectedDate = getNextAvailableDate(today);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// ---- Time Slots ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Available Time Slots",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = timeSlots[index];
                  final status = slot["status"]!;
                  final isSelected =
                      status == "selected" || slot["time"] == selectedTime;

                  Color bgColor() {
                    if (isSelected) return Colors.deepPurple;
                    if (status == "available") return Colors.white;
                    return Colors.grey.shade300;
                  }

                  Color textColor() {
                    if (isSelected) return Colors.white;
                    if (status == "available") return Colors.black;
                    return Colors.grey.shade600;
                  }

                  String label() {
                    if (isSelected) return "Selected";
                    if (status == "available") return "Available";
                    return "Not Available";
                  }

                  return GestureDetector(
                    onTap: status == "available"
                        ? () {
                            setState(() {
                              selectedTime = slot["time"]!;
                            });
                          }
                        : null,
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor(),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot["time"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label(),
                            style: TextStyle(fontSize: 12, color: textColor()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            /// ---- Car Details ----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Car Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.refresh,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Car Make",
                    "e.g., Toyota",
                    carMakeController,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Car Model",
                    "e.g., Camry",
                    carModelController,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "License Plate",
                    "e.g., ABC 123",
                    licensePlateController,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: carType,
                    items: ["Sedan", "SUV", "Hatchback", "Truck"]
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        carType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Car Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// ---- Confirm Button ----
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Booking logic

                  final bookingDetails =
                      '''
Date: ${selectedDate.day} ${_monthName(selectedDate.month)}, ${selectedDate.year}
Time Slot: $selectedTime
Car Make: ${carMakeController.text}
Car Model: ${carModelController.text}
License Plate: ${licensePlateController.text}
Car Type: $carType
''';
                  print(bookingDetails);
 Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => BookingConfirmationScreen(
        selectedDate: selectedDate,
        selectedTime: selectedTime!,
        carMake: carMakeController.text,
        carModel: carModelController.text,
        licensePlate: licensePlateController.text,
        carType: carType,
      ),
    ),);
                },
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
