import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final String carMake;
  final String carModel;
  final String licensePlate;
  final String carType;
  final bool isMonthlyBooking;

  const BookingConfirmationScreen({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.carMake,
    required this.carModel,
    required this.licensePlate,
    required this.carType,
    this.isMonthlyBooking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Confirmation",
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
            // Booking Confirmed Header
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Booking Confirmed!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your car wash booking has been successfully placed. We look forward to serving you!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 13),
            
            // Divider
            const Divider(thickness: 1),
            const SizedBox(height: 5),
            
            // Date & Time Section
            const Text(
              "Date & Time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailItem(
              icon: Icons.calendar_today,
              title: "Date",
              value: "${_formatDate(selectedDate)}",
            ),
            const SizedBox(height: 8),
            _buildDetailItem(
              icon: Icons.access_time,
              title: "Time Set",
              value: selectedTime,
              isChecked: true,
            ),
            const SizedBox(height: 24),
            
            // Divider
            const Divider(thickness: 1),
            const SizedBox(height: 5),
            
            // Car Details Section
            const Text(
              "Car Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailItem(
              icon: Icons.directions_car,
              title: "Make",
              value: carMake,
            ),
            const SizedBox(height: 8),
            _buildDetailItem(
              icon: Icons.model_training,
              title: "Model",
              value: carModel,
              isChecked: true,
            ),
            const SizedBox(height: 8),
            _buildDetailItem(
              icon: Icons.color_lens,
              title: "Color",
              value: carType, // Using carType as color for this example
              isChecked: true,
            ),
            const SizedBox(height: 8),
            _buildDetailItem(
              icon: Icons.confirmation_number,
              title: "License Plate",
              value: licensePlate,
              isChecked: true,
            ),
            const SizedBox(height: 24),
            
            // Monthly Booking Notice
            if (isMonthlyBooking) ...[
              const Text(
                "Monthly Booking",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Cancel Booking Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle cancel booking
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel Booking",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isChecked = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox or icon
       // isChecked
         //   ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
           // : const Icon(Icons.radio_button_unchecked, size: 20),
        const SizedBox(width: 12),
        
        // Icon
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        
        // Title and value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
