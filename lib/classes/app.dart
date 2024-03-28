import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../imports.dart';

// 小数部が0でない場合は小数点以下を最大2桁まで表示
String formatNumber(double value) {
  String format = value.remainder(1) == 0 ? '#,##0' : '#,##0.##';
  return NumberFormat(format, 'en_US').format(value);
}

// 日付と時間を組み合わせる
DateTime combineDateAndTime(String dateString, String timeString) {
  final date = DateFormat('yyyy-MM-dd').parse(dateString);
  final time = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(timeString));
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}

// 日付表示
String formatDate(DateTime selected, bool isJP) {
  initializeDateFormatting();
  final locale = isJP ? 'ja' : 'en';
  final format = isJP ? 'yyyy年MM月dd日(E)' : 'yyyy/MM/dd(E)';
  final formatter = DateFormat(format, locale);
  final formattedDate = formatter.format(selected);
  return formattedDate;
}
