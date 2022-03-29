const bool SHOW_DETAIL_LOGS = false;
const bool SHOW_MIN_LOGS = false;

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}