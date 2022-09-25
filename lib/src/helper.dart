import 'package:counter/src/microblog.dart';

const String canisterId = "wqfjv-niaaa-aaaam-aas6a-cai";
const String url = "https://ic0.app";
String whoami = "loading";

// const String canisterId = "rrkah-fqaaa-aaaaa-aaaaq-cai";
// const String url = "http://127.0.0.1:8000";

/// 格式化时间
String simplyFormat({required DateTime time, bool dateOnly = false}) {
  String year = time.year.toString();
  // Add "0" on the left if month is from 1 to 9
  String month = time.month.toString().padLeft(2, '0');
  // Add "0" on the left if day is from 1 to 9
  String day = time.day.toString().padLeft(2, '0');
  // Add "0" on the left if hour is from 1 to 9
  String hour = time.hour.toString().padLeft(2, '0');
  // Add "0" on the left if minute is from 1 to 9
  String minute = time.minute.toString().padLeft(2, '0');
  // Add "0" on the left if second is from 1 to 9
  String second = time.second.toString();
  // If you only want year, month, and date
  if (dateOnly == false) {
    return "$year-$month-$day $hour:$minute:$second";
  }
  // return the "yyyy-MM-dd HH:mm:ss" format
  return "$year-$month-$day";
}

getTime(String value) {
  int time = num.parse(value).toInt();
  return time ~/ 1000000;
}

// setup state class variable;
MicroBlog? microBlog;

Future<String?> initCanister(String canisterId, String url) async {
  // initialize counter, change canister id here
  if (null == microBlog) {
    microBlog = MicroBlog(canisterId: canisterId, url: url);
  }
  await microBlog?.setAgent(newIdentity: null);
  return await microBlog?.getName();
}
