import '../model/booking_model.dart';
import '../repository/booking_repository.dart';
import '../view/booking_view.dart';

class BookingPresenter {
  final BookingView view;
  final BookingRepository repository;

  BookingPresenter({
    required this.view,
    required this.repository,
  });

  void onCancelBooking(BookingModel booking) async {
    view.showLoading();
    try {
      await repository.cancelBooking(booking);
      view.onBookingCancelled();
    } catch (e) {
      view.showError("Failed to cancel booking: $e");
    } finally {
      view.hideLoading();
    }
  }
}
