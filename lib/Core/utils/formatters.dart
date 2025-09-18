
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDateFromTimestamp(dynamic timestamp) {
  if (timestamp == null) return 'Unknown';
  
  try {
    DateTime date;
    
    if (timestamp is Timestamp) {
      // Handle Firestore Timestamp
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      // Handle DateTime object directly
      date = timestamp;
    } else if (timestamp is String) {
      // Handle string representation (optional)
      date = DateTime.parse(timestamp);
    } else {
      return 'Unknown format';
    }
    
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    print('Error formatting date: $e');
    return 'Unknown';
  }
}