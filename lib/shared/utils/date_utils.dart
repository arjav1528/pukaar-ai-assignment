/// Local-calendar day key `YYYY-MM-DD` for bucketing entries.
String dateKeyFromDate(DateTime date) {
  final local = DateTime(date.year, date.month, date.day);
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime startOfDayFromDateKey(String dateKey) {
  final parts = dateKey.split('-');
  if (parts.length != 3) return DateTime.now();
  final y = int.tryParse(parts[0]) ?? 0;
  final m = int.tryParse(parts[1]) ?? 1;
  final d = int.tryParse(parts[2]) ?? 1;
  return DateTime(y, m, d);
}
