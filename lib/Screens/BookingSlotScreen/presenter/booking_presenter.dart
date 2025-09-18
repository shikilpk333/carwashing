import '../model/booking_model.dart';
import '../repository/booking_repository.dart';

abstract class BookingView {
  void showLoading();
  void hideLoading();
  void showTimeSlots(List<BookingSlot> slots);
  void showError(String message);
  void onBookingSuccess();
  void onDateChanged(DateTime newDate);
  void onTimeSlotSelected(String timeSlot);
}

class BookingPresenter {
  final BookingRepository repository;
  BookingView? _view;

  DateTime _selectedDate;
  String? _selectedTimeSlot;
  final List<String> _carTypes = ["Sedan", "SUV", "Hatchback", "Truck"];
  List<BookingSlot> _availableSlots = [];

  BookingPresenter({
    required this.repository,
    required DateTime initialDate,
  }) : _selectedDate = initialDate;

  void attachView(BookingView view) => _view = view;
  void detachView() => _view = null;

  DateTime get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  List<String> get carTypes => _carTypes;
  List<BookingSlot> get availableSlots => _availableSlots;

  /*DateTime getInitialDate() {
    DateTime today = DateTime.now();
    if (today.weekday == DateTime.sunday) {
      today = today.add(const Duration(days: 1));
    }
    return today;
  }*/

  static DateTime getInitialDate() {
    DateTime today = DateTime.now();
    if (today.weekday == DateTime.sunday) {
      today = today.add(const Duration(days: 1));
    }
    return today;
  }

  DateTime getNextAvailableDate(DateTime from) {
    DateTime nextDay = from.add(const Duration(days: 1));
    if (nextDay.weekday == DateTime.sunday) {
      nextDay = nextDay.add(const Duration(days: 1));
    }
    return nextDay;
  }

  DateTime getPreviousAvailableDate(DateTime from) {
    DateTime prevDay = from.subtract(const Duration(days: 1));
    if (prevDay.weekday == DateTime.sunday) {
      prevDay = prevDay.subtract(const Duration(days: 1));
    }
    return prevDay;
  }

  Future<void> loadTimeSlots() async {
    _view?.showLoading();
    try {
      _availableSlots = await repository.getAvailableTimeSlots(_selectedDate);
      _view?.showTimeSlots(_availableSlots);
    } catch (e) {
      _view?.showError('Failed to load time slots: $e');
    } finally {
      _view?.hideLoading();
    }
  }

  Future<void> selectDate(DateTime newDate) async {
    _selectedDate = newDate;
    _selectedTimeSlot = null;
    _view?.onDateChanged(newDate);
    await loadTimeSlots();
  }

  void selectTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    _view?.onTimeSlotSelected(timeSlot);
  }

  Future<void> navigateToNextDay() async {
    final nextDate = getNextAvailableDate(_selectedDate);
    await selectDate(nextDate);
  }

  Future<void> navigateToPreviousDay() async {
    final prevDate = getPreviousAvailableDate(_selectedDate);
    if (prevDate.isAfter(getInitialDate().subtract(const Duration(days: 1)))) {
      await selectDate(prevDate);
    }
  }

  Future<void> confirmBooking(CarDetails carDetails) async {
    if (_selectedTimeSlot == null) {
      _view?.showError('Please select a time slot');
      return;
    }

    if (!_isValidCarDetails(carDetails)) {
      _view?.showError('Please fill all car details');
      return;
    }

    final bookingDetails = BookingDetails(
      date: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      carDetails: carDetails,
    );

    _view?.showLoading();
    try {
      final isAvailable = await repository.checkSlotAvailability(
        _selectedDate,
        _selectedTimeSlot!,
      );

      if (!isAvailable) {
        _view?.showError('This time slot is no longer available');
        return;
      }

      final success = await repository.bookSlot(bookingDetails);
      if (success) {
        _view?.onBookingSuccess();
      } else {
        _view?.showError('Booking failed. Please try again.');
      }
    } catch (e) {
      _view?.showError('Booking failed: $e');
    } finally {
      _view?.hideLoading();
    }
  }

  bool _isValidCarDetails(CarDetails carDetails) {
    return carDetails.make.isNotEmpty &&
        carDetails.model.isNotEmpty &&
        carDetails.licensePlate.isNotEmpty;
  }

  

  String formatDate(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${date.day} ${months[date.month - 1]}, ${date.year}";
  }
}