class DateFormatter {
  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  /// Mengubah DateTime atau String ISO8601 menjadi format "08 Juli 2026"
  static String toIndonesianDate(dynamic dateValue) {
    if (dateValue == null) return '-';
    
    DateTime? dateTime;
    
    if (dateValue is DateTime) {
      dateTime = dateValue;
    } else if (dateValue is String) {
      dateTime = DateTime.tryParse(dateValue);
    }
    
    if (dateTime == null) return '-';
    
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = _months[dateTime.month - 1];
    String year = dateTime.year.toString();
    
    return '$day $month $year';
  }
}
