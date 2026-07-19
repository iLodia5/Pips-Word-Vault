import 'dart:io';

void main() {
  var file = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\ezgif.com-video-to-webp-converter.webp');
  var bytes = file.readAsBytesSync();
  
  // WEBP header is "RIFF" .... "WEBPVP8 " or similar.
  // Actually, wait, it's easier to just use `image` package or Dart's `decodeImageFromList`.
  // Wait, `decodeImageFromList` requires flutter, so we can't run it in plain dart easily if it uses `dart:ui`.
  // Let's just output the first 30 bytes to see if it's WEBP extended
}
