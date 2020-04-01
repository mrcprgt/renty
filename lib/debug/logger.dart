import 'package:logger/logger.dart';
import 'log_printer.dart';

// Logger getLogger(String className) {
//   return Logger(printer: SimpleLogPrinter(className));
// }

Logger getLogger(String className) {
  return Logger(
      printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 3,
    lineLength: 130,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));
}
