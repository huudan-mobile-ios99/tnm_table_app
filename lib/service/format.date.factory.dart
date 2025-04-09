import 'package:intl/intl.dart' show DateFormat;

class DateFormatter {
  DateTime parseDateString(String createdAtString) {
    // Split the createdAtString by spaces
    List<String> parts = createdAtString.split(' ');
    // Extract date components
    String weekday = parts[0];
    String month = parts[1];
    int day = int.parse(parts[2]);
    int year = int.parse(parts[3]);
    String time = parts[4];
    String timezone = parts[5];
    // Extract time components
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);
    // Construct DateTime object
    final DateTime date =
        DateTime(year, _parseMonth(month), day, hour, minute, second);
    print('date parse string : $date');
    return date;
  }

  int _parseMonth(String month) {
    switch (month) {
      case 'Jan':
        return DateTime.january;
      case 'Feb':
        return DateTime.february;
      case 'Mar':
        return DateTime.march;
      case 'Apr':
        return DateTime.april;
      case 'May':
        return DateTime.may;
      case 'Jun':
        return DateTime.june;
      case 'Jul':
        return DateTime.july;
      case 'Aug':
        return DateTime.august;
      case 'Sep':
        return DateTime.september;
      case 'Oct':
        return DateTime.october;
      case 'Nov':
        return DateTime.november;
      case 'Dec':
        return DateTime.december;
      default:
        throw FormatException('Invalid month: $month');
    }
  }

  String formatDate(value) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(value);
    return formattedDate;
  }

  String formatDateReverse(value) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(value);
    return formattedDate;
  }

  String formatDateString(value) {
    String formattedDate = DateFormat('yyyy_MM_dd').format(value);
    return formattedDate;
  }

  String formatDateSlash(value) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(value);
    return formattedDate;
  }

  String formatDateMonthYear(value) {
    String formattedDate = DateFormat('MM/yyyy').format(value);
    return formattedDate;
  }

  //IMPORTANT
  String formatDateAFullLocal(DateTime value) {
    //If you want to parse in Flutter
    DateTime date = DateTime.parse(value.toString()).toUtc();
    DateTime dateLocal = date.toLocal();
    String formattedDate = DateFormat('(EEE) HH:mm:ss dd/MM/yyyy ').format(dateLocal);
    return formattedDate;
  }

  //IMPORTANT
  String formatTimeAFullLocal(DateTime value) {
    //If you want to parse in Flutter
    DateTime date = DateTime.parse(value.toString()).toUtc();
    DateTime dateLocal = date.toLocal();
    String formattedDate = DateFormat('HH:mm:ss').format(dateLocal);
    return formattedDate;
  }
   String FormatTime(value) {
    String formattedDate = DateFormat('HH:mm').format(value);
    return formattedDate;
  }

  String formatDateOnlyDay(value) {
    String formattedDate = DateFormat('dd').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayText2(value) {
    String formattedDate = DateFormat('EE').format(value);
    return formattedDate;
  }

  String formatDateWithTime(value) {
    String formattedDate = DateFormat('Hms').format(value);
    return formattedDate;
  }

  DateTime formatDateWithTimeReverse(value) {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(value);
    return tempDate;
  }

  String formatDateAndTime(value) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
    return formattedDate;
  }

  String formatDateAndTimeFirst(value) {
    String formattedDate = DateFormat('HH:mm (EEE) dd-MM-yyyy ').format(value);
    return formattedDate;
  }

  String formatDateAndTime2(value) {
    String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(value);
    return formattedDate;
  }


  String FormatDate(value) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(value);
    return formattedDate;
  }

  String FormatTimeFullW(value) {
    String formattedDate = DateFormat('HH:mm ').format(value);
    return formattedDate;
  }

  String FormatTimeFull(value) {
    String formattedDate = DateFormat('HH:mm:ss').format(value);
    return formattedDate;
  }

  String formatDateWithSplash(value) {
    String formattedDate = DateFormat('EEE dd/MM').format(value);
    return formattedDate;
  }

  String formatMonthYear(value) {
    String formattedDate = DateFormat('MMMM yyyy').format(value);
    return formattedDate;
  }

  String formatMonthNum(value) {
    String formattedDate = DateFormat('MM').format(value);
    return formattedDate;
  }

  String formatYearNum(value) {
    String formattedDate = DateFormat('yyyy').format(value);
    return formattedDate;
  }

  String formatDateWithDay(value) {
    String formattedDate = DateFormat('EEE dd').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayText(value) {
    String formattedDate = DateFormat('EEE').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayDD(value) {
    String formattedDate = DateFormat('EEE').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayDDDate(value) {
    String formattedDate = DateFormat('EEE dd MM').format(value);
    return formattedDate;
  }

  String formatDayDateTime(value) {
    String formattedDate =
        DateFormat('yyyy-MM-dd (EEE)  HH:mm:ss').format(value);
    return formattedDate;
  }

  String formatDayDateTimeDisplay(value) {
    String formattedDate = DateFormat('dd MMM yyyy, ').add_jm().format(value);
    return formattedDate;
  }

  String formatDayDateTimeFull(value) {
    String formattedDate = DateFormat('yyyy-MM-dd  HH:mm:ss a').format(value);
    return formattedDate;
  }


    String formatDateAFullLocalStandar(DateTime value) {
    //If you want to parse in Flutter
    DateTime date = DateTime.parse(value.toString()).toUtc();
    DateTime dateLocal = date.toLocal();
    String formattedDate = DateFormat(' HH:mm:ss dd-MM-yyyy ').format(dateLocal);
    return formattedDate;
  }
}
