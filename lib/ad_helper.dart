import 'dart:io';

class AdHelper {

  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3902063438115378/5036127612';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-3902063438115378/3723045943';
  //   } else {
  //     return '';
  //   }
  // }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      return '';
    }
  }
}