import 'package:flutter/material.dart';
import '../model/booking_model.dart';
import '../presenter/booking_presenter.dart';
import '../repository/booking_repository.dart';
import 'booking_view.dart';


class BookingConfirmationScreen extends StatefulWidget {
  final BookingModel booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

/*

class BookingConfirmationScreen extends StatefulWidget {
  final BookingModel booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}*/

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    implements BookingView {
  late BookingPresenter presenter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    presenter = BookingPresenter(
      view: this,
      repository: BookingRepositoryImpl(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 64),
                      SizedBox(height: 16),
                      Text("Booking Confirmed!",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        "Your car wash booking has been successfully placed. We look forward to serving you!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 12),

                // Date & Time
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  title: "Date",
                  value: _formatDate(booking.selectedDate),
                ),
                const SizedBox(height: 8),
                _buildDetailItem(
                  icon: Icons.access_time,
                  title: "Time",
                  value: booking.selectedTime,
                ),
                const Divider(thickness: 1),

                // Car details
                _buildDetailItem(
                    icon: Icons.directions_car,
                    title: "Make",
                    value: booking.carMake),
                _buildDetailItem(
                    icon: Icons.model_training,
                    title: "Model",
                    value: booking.carModel),
                _buildDetailItem(
                    icon: Icons.color_lens,
                    title: "Type/Color",
                    value: booking.carType),
                _buildDetailItem(
                    icon: Icons.confirmation_number,
                    title: "License Plate",
                    value: booking.licensePlate),

               /* if (booking.isMonthlyBooking)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      "Monthly Booking",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple),
                    ),
                  ),*/

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        presenter.onCancelBooking(widget.booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Cancel Booking"),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
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
      "December"
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  // BookingView implementation
  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void showLoading() => setState(() => _isLoading = true);

  @override
  void onBookingCancelled() {
    Navigator.pop(context); // Go back after cancel
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Booking Cancelled")));
  }
}
