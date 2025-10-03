import 'package:carwashbooking/Screens/AddressScreen/Model/addressmodel.dart';
import 'package:carwashbooking/Screens/BookingConfirmation/model/booking_model.dart';
import 'package:carwashbooking/Screens/BookingConfirmation/view/booking_confirmation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../presenter/booking_presenter.dart';
import '../model/booking_model.dart';
import '../repository/booking_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotBookingScreen extends StatefulWidget {
  const SlotBookingScreen({super.key});

  @override
  State<SlotBookingScreen> createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen>
    implements BookingView {
  late BookingPresenter presenter;

  String? selectedAddressId;
List<AddressModel> userAddresses = [];


  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

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
      initialDate: BookingPresenter.getInitialDate(),
    );

    presenter.attachView(this);
    presenter.loadTimeSlots();

      _loadUserAddresses();
  }

Future<void> _loadUserAddresses() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  
  //final uid = FirebaseFirestore.instance.auth().currentUser?.uid;
  if (uid == null) return;

  final snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("addresses")
      .get();

  setState(() {
    userAddresses = snapshot.docs
        .map((doc) => AddressModel.fromMap(doc.data()))
        .toList();

    if (userAddresses.isNotEmpty) {
      selectedAddressId = userAddresses.first.id;
    }
  });
}

  @override
  void dispose() {
    presenter.detachView();
    carMakeController.dispose();
    carModelController.dispose();
    licensePlateController.dispose();
    notesController.dispose();
    yearController.dispose();
    colorController.dispose();
    super.dispose();
  }

  @override
  void showLoading() => setState(() => isLoading = true);

  @override
  void hideLoading() => setState(() => isLoading = false);

  @override
  void showTimeSlots(List<BookingSlot> slots) =>
      setState(() => timeSlots = slots);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Choose Slot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildServiceAndAddress(),
                        const SizedBox(height: 20),
                        _buildDateAndSlots(),
                        const SizedBox(height: 20),
                        _buildCarDetailsForm(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
    );
  }

  /// --- Top cards ---
  
  /// --- Top cards ---
/// Now shows dropdown to choose an address
Widget _buildServiceAndAddress() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF121B2C),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Choose Address",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        userAddresses.isEmpty
            ? const Text("No saved addresses. Please add one in profile.",
                style: TextStyle(color: Colors.white70))
            : DropdownButtonFormField<String>(
                value: selectedAddressId,
                dropdownColor: const Color(0xFF1A2235),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1A2235),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                items: userAddresses.map((address) {
                  return DropdownMenuItem(
                    value: address.id,
                    child: Text(
                      "${address.address}, ${address.city} - ${address.postalCode}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAddressId = value;
                  });
                },
              ),
      ],
    ),
  );
}

  
  
  /*Widget _buildServiceAndAddress() {
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildInfoCard("Home", "Enter address", "Edit"),
      ],
    );
  }*/

  Widget _buildInfoCard(String title, String subtitle, String actionText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121B2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
              ],
            ),
          ),
          Text(actionText,
              style: const TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// --- Date and Slots ---
  Widget _buildDateAndSlots() {
    final today = BookingPresenter.getInitialDate();
    final tomorrow = today.add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select date",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // Today / Tomorrow toggle
        Row(
          children: [
            ChoiceChip(
              label: const Text("Today"),
              selected: presenter.selectedDate.day == today.day &&
                  presenter.selectedDate.month == today.month,
              onSelected: (_) => presenter.selectDate(today),
              labelStyle: TextStyle(
                color: presenter.selectedDate.day == today.day
                    ? Colors.white
                    : Colors.white70,
              ),
              selectedColor: Colors.blueAccent,
              backgroundColor: const Color(0xFF1A2235),
            ),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text("Tomorrow"),
              selected: presenter.selectedDate.day == tomorrow.day &&
                  presenter.selectedDate.month == tomorrow.month,
              onSelected: (_) => presenter.selectDate(tomorrow),
              labelStyle: TextStyle(
                color: presenter.selectedDate.day == tomorrow.day
                    ? Colors.white
                    : Colors.white70,
              ),
              selectedColor: Colors.blueAccent,
              backgroundColor: const Color(0xFF1A2235),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const Text("Available Time Slots",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // Grid-aligned slots
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: timeSlots.map((slot) {
            final isSelected = presenter.selectedTimeSlot == slot.time;
            final isAvailable = slot.status == "available";

            return GestureDetector(
              onTap:
                  isAvailable ? () => presenter.selectTimeSlot(slot.time) : null,
              child: Container(
                width: 80,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blueAccent
                      : isAvailable
                          ? const Color(0xFF1A2235)
                          : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    slot.time,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isAvailable
                              ? Colors.white
                              : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// --- Car Details Form ---
  Widget _buildCarDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121B2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Car details",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildDarkTextField("Car make", "e.g., Toyota", carMakeController),
          const SizedBox(height: 12),
          _buildDarkTextField("Model", "e.g., Corolla", carModelController),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildDarkTextField("Year", "e.g., 2020", yearController)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDarkTextField("Color", "e.g., Silver", colorController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildDarkTextField(
              "License plate", "ABC-1234", licensePlateController),
          const SizedBox(height: 12),
          _buildDarkTextField("Notes for washer (optional)",
              "Gate code, parking info, pet in car, etc.", notesController),
        ],
      ),
    );
  }

  Widget _buildDarkTextField(
      String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: const Color(0xFF1A2235),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  /// --- Bottom Buttons ---
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0F1C),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blueAccent),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Back",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
              child: const Text("Confirm Slot",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
