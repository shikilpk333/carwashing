import 'package:carwashbooking/Screens/BookingConfirmation/model/booking_model.dart';
import 'package:carwashbooking/Screens/BookingConfirmation/view/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import '../presenter/booking_presenter.dart';
import '../model/booking_model.dart';
import '../repository/booking_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carwashbooking/Screens/BookingConfirmation.dart';

class SlotBookingScreen extends StatefulWidget {
  const SlotBookingScreen({super.key});

  @override
  State<SlotBookingScreen> createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen> implements BookingView {
  late BookingPresenter presenter;
  
  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  String selectedCarType = "Sedan";
  
  bool isLoading = false;
  List<BookingSlot> timeSlots = [];
@override
void initState() {
  super.initState();
  
  presenter = BookingPresenter(
    repository: FirebaseBookingRepository(
      firestore: FirebaseFirestore.instance,
    ),
    initialDate: BookingPresenter.getInitialDate(), // Use static method
  );
  
  presenter.attachView(this);
  presenter.loadTimeSlots();
}

 


  @override
  void dispose() {
    presenter.detachView();
    carMakeController.dispose();
    carModelController.dispose();
    licensePlateController.dispose();
    super.dispose();
  }

  @override
  void showLoading() => setState(() => isLoading = true);

  @override
  void hideLoading() => setState(() => isLoading = false);

  @override
  void showTimeSlots(List<BookingSlot> slots) => setState(() => timeSlots = slots);

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

@override
void onBookingSuccess() {
  final booking = BookingModel(
    selectedDate: presenter.selectedDate,
    selectedTime: presenter.selectedTimeSlot!,
    carMake: carMakeController.text,
    carModel: carModelController.text,
    licensePlate: licensePlateController.text,
    carType: selectedCarType,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => BookingConfirmationScreen(booking: booking),
    ),
  );
}

  @override
  void onDateChanged(DateTime newDate) => setState(() {});

  @override
  void onTimeSlotSelected(String timeSlot) => setState(() {});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: presenter.selectedDate,
      firstDate: BookingPresenter.getInitialDate(),
      lastDate: presenter.getNextAvailableDate(presenter.selectedDate),
    );

    if (picked != null) {
      await presenter.selectDate(picked);
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  const SizedBox(height: 20),
                  _buildTimeSlots(),
                  const SizedBox(height: 20),
                  _buildCarDetailsForm(),
                  const SizedBox(height: 24),
                  _buildConfirmButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                onPressed: presenter.navigateToPreviousDay,
              ),
              Text(
                presenter.formatDate(presenter.selectedDate),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: presenter.navigateToNextDay,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              final isSelected = presenter.selectedTimeSlot == slot.time;
              final isAvailable = slot.status == "available";

              return GestureDetector(
                onTap: isAvailable
                    ? () => presenter.selectTimeSlot(slot.time)
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.deepPurple : 
                           isAvailable ? Colors.white : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        slot.time,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : 
                                 isAvailable ? Colors.black : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSelected ? "Selected" : 
                        isAvailable ? "Available" : "Not Available",
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : 
                                 isAvailable ? Colors.black : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarDetailsForm() {
    return Container(
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(Icons.refresh, size: 18, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField("Car Make", "e.g., Toyota", carMakeController),
          const SizedBox(height: 12),
          _buildTextField("Car Model", "e.g., Camry", carModelController),
          const SizedBox(height: 12),
          _buildTextField("License Plate", "e.g., ABC 123", licensePlateController),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedCarType,
            items: presenter.carTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) => setState(() => selectedCarType = value!),
            decoration: InputDecoration(
              labelText: "Car Type",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          final carDetails = CarDetails(
            make: carMakeController.text,
            model: carModelController.text,
            licensePlate: licensePlateController.text,
            type: selectedCarType,
          );
          presenter.confirmBooking(carDetails);
        },
        child: const Text(
          "Confirm Booking",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}