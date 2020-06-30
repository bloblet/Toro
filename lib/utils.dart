enum Severity { info, success, warning, error }
const debug = true;
void log(dynamic log, {Severity type = Severity.info}) {
  if (!debug) return;
  String message = '';
  switch (type) {
    case Severity.info:
      message += '\u001b[1m\u001b[36;1m[INFO]\u001b[0m\u001b[36m    ';
      break;
    case Severity.success:
      message += '\u001b[1m\u001b[32;1m[SUCCESS]\u001b[0m\u001b[32m ';
      break;
    case Severity.warning:
      message += '\u001b[1m\u001b[33;1m[WARNING]\u001b[0m\u001b[33m ';
      break;
    case Severity.error:
      message += '\u001b[1m\u001b[31;1m[ERROR]\u001b[0m\u001b[31m   ';
      break;
  }
  message += log.toString();
  message += '\u001b[0m';
  print(message);
}
msDiff(DateTime first, DateTime other) => first.difference(other).inMilliseconds;