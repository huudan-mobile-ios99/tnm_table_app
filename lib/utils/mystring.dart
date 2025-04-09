import 'package:flutter/foundation.dart';

class MyString {
  static const int DEFAULTNUMBER = 111111;
  static const String DEFAULT_USERNAME = 'admin_vegas';
  static const String DEFAULTP_PASS = 'admin_vegas';
  static const String APP_NAME = "TNM TABLE";
  // static const String ADRESS_SERVER = "localhost";
  // static const String ADRESS_SERVER = "10.20.10.36";
  static const String ADRESS_SERVER = "192.168.101.58";
  static const String BASE = 'http://$ADRESS_SERVER:8083/api/';
  static const String BASEURL = 'http://$ADRESS_SERVER:8083/';
  // static const String BASEURL = 'http://$ADRESS_SERVER:8086/';
  static const String API_KEY = '';
  static const String list_ranking = '${BASE}list_ranking';
  static const String list_ranking_data = '${BASE}list_ranking_data';
  static const String export_round = '${BASE}export_round';
  static const String export_round_realtime = '${BASE}export_round_realtime';
  static String downloadround(name) {
    String url = '${BASE}download_excel/$name';
    debugPrint(url);
    return url;
  }

  static const String list_round = '${BASE}list_round';
  static const String list_round_realtime = '${BASE}list_ranking_realtime_group';
  static const String create_round = '${BASE}create_round';
  static const String create_round_realtime = '${BASE}save_list_station';
  static const String create_round_input = '${BASE}create_round_input';
  static const String create_ranking = '${BASE}add_ranking';
  static const String update_ranking = '${BASE}update_ranking';
  static const String update_ranking_by_id = '${BASE}update_ranking_id';
  static const String delete_ranking = '${BASE}delete_ranking';
  static String delete_ranking_byid(id) {
    final url = '${BASE}delete_ranking_id/$id';
    debugPrint('delete_ranking_by id url : $url');
    return url;
  }

  static const String delete_ranking_all_and_add = '${BASE}delete_ranking_all_create_default';
  static const String list_station = '${BASE}list_station';
  static const String update_member_station = '${BASE}update_member';
  static const String create_station = '${BASE}create_station';
  static const String delete_station = '${BASE}delete_station';
  static const String update_station_status = '${BASE}update_station';
  static const String update_status_all = '${BASE}update_status_all';
  static const String add_ranking_realtime = '${BASE}add_ranking_realtime';
  static const String settings = '${BASE}findsetting';
  static const String setting_update = '${BASE}update_setting';
  static const String setting_update_game = '${BASE}setting/update_setting';
  static const String setting_update_table_game = '${BASE}update_setting';
  //JACKPOT HISTORY
  static const String jackpot_history =  '${BASE}jackpot_drop/jackpot_drop_paging?page=1&limit=30';

  //DEFAULT PADDING IN SETTING
  static const double TOP_PADDING_TOPRAKINGREALTIME = 18.0;

  //DISPLAY
  static String update_display(id) {
    return '${BASE}update_display/$id';
  }

  //DISPLAY REALTOP
  static String update_display_realtop(id) {
    return '${BASE}update_display_realtop/$id';
  }

  //DISPLAY
  static String list_display = '${BASE}list_display';

  //TIME
  static const String get_latest_active_time = '${BASE}time/find_time_first';
  static const String update_time_by_id = '${BASE}time/update_time';
  static const String update_time_latest = '${BASE}time/update_time_latest';
  //STREAM
  static const String get_stream_all = '${BASE}stream/all_stream';
  //JACKPOT
  static const String get_jackpot_all = '${BASE}jackpot/all_jackpot';
  static String delete_jackpot_by_id(id) {
    return '${BASE}jackpot_drop/delete_jackpot_drop/$id';
  }

  //DEVICE
  static const CREATE_NEW_DEVICE = "${BASE}device/create_device";
  static const LIST_DEVICE_ALL = "${BASE}device/list_device";
  static String delete_device_by_id(id) {
    return '${BASE}device/delete_device/$id';
  }

  static String update_device_by_id(id) {
    return '${BASE}device/update_device/$id';
  }

  static const int TIME_INIT = 0;
  static const int TIME_START = 1;
  static const int TIME_PAUSE = 2;
  static const int TIME_RESUME = 3;
  static const int TIME_STOP = 4;
  static const int TIME_SET = 5;

  static const int TIME_DEFAULT_MINUTES = 5;

  static String list_data_station = '${BASE}find_data';
  //login
  static String login = '${BASE}login';

  //default column in settting server
  static const String DEFAULT_COLUMN = '8';
  static const double DEFAULT_HEIGHT_LINE = kIsWeb ? 70.5 : 36.5;
  static const double DEFAULT_SPACING_LING = kIsWeb ? 45 : 18.5;
  // static const double DEFAULT_HEIGHT_LINE = kIsWeb ? 34.5 : 36.5;
  // static const double DEFAULT_SPACING_LING = kIsWeb ? 18.5 : 18.5;

  static const double DEFAULT_ROW = 9;
  // static const double DEFAULT_OFFSETX = 2;
  static const double DEFAULT_OFFSETX = 2.5;
  static const double DEFAULT_OFFSETX_TEXT_VERTICAL = 2.5;
  static const double DEFAULT_OFFSETX_TITLE = 2.5;


  // // //FOR REALTIME RANKING LARGER TEXT SIZE
  // // static const double DEFAULT_TEXTSIZE = 57.5;
  // // static const double DEFAULT_TEXTSIZE_WEB = 57.5;
  // //FOR TOP RANKING NORMAL TEXT SIZE
  // static const double DEFAULT_TEXTSIZE = 43.5;
  // static const double DEFAULT_TEXTSIZE_WEB = 43.5;


  //TEXTSIZE FOR 5 ITEM RANKING
  static const double DEFAULT_TEXTSIZE = 48.5;
  static const double DEFAULT_TEXTSIZE_WEB = 48.5;


  //FOR TOP RANKING
  // static const double DEFAULT_TEXTSIZE = 57.5;
  // static const double DEFAULT_TEXTSIZE_WEB = 57.5;
  static const double DEFAULT_TEXTSIZE_TITLE = 47.5;
  static const double DEFAULT_TEXTSIZE_WEB_TITLE = 47.5;
  // static const double DEFAULT_TEXTSIZE = 24.0;
  // static const double DEFAULT_TEXTSIZE_WEB = 32;
  static const double DEFAULT_TEXTSIZE_DRAWLINE = 11;
  static const double DEFAULT_TEXTSIZE_DRAWLINE_WEB = 16;

  //border radius default
  static const double DEFAULT_BORDERRADIUS = 3.5;

  static const double padding02 = 02.0;
  static const double padding04 = 04.0;
  static const double padding06 = 06.0;
  static const double padding08 = 08.0;
  static const double padding10 = 10.0;
  static const double padding16 = 16.0;
  static const double padding17 = 17.0;
  static const double padding12 = 12.0;
  static const double padding14 = 14.0;
  static const double padding19 = 18.5;
  static const double padding20 = 20.0;
  static const double padding22 = 22.0;
  static const double padding24 = 24.0;
  static const double padding26 = 26.0;
  static const double padding28 = 28.0;
  static const double padding18 = 18.0;
  static const double padding32 = 32.0;
  static const double padding36 = 36.0;
  static const double padding38 = 38.0;
  static const double padding42 = 42.0;
  static const double padding46 = 46.0;
  static const double padding48 = 48.0;
  static const double padding56 = 56.0;
  static const double padding64 = 64.0;
  static const double padding72 = 72.0;
  static const double padding84 = 84.0;
  static const double padding96 = 96.0;
  static const double padding116 = 116.0;
  static const String fontFamily = 'Poppins';

  //JP MAX
  static const double JPPercentMax = 5;
  //JP Min Max Value
  static const double JPPriceMin = 50;
  static const double JPPriceMax = 100;
  static const double JPPricePercent = 0.5;
  static const double JPPriceThresHold = 85;
  static const int JPThrotDuration = 7; //7 seconds
  //JP Min Max Value
  static const double JPPriceMin2 = 20;
  static const double JPPriceMax2 = 70;
  static const double JPPricePercent2 = 0.5;
  static const double JPPriceThresHold2 = 45;
  static const int JPThrotDuration2 = 7; //6 seconds
  static const int JPShowDelayTime = 7; //6 seconds
}
