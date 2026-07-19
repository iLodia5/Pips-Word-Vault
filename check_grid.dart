import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final bytes = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\Cheering-ezgif.com-gif-to-sprite-converter.png').readAsBytesSync();
  final image = img.decodePng(bytes);
  if (image == null) return;
  print('Width: \${image.width}, Height: \${image.height}');
  
  // scan for blank rows (all alpha == 0)
  int rowGaps = 0;
  bool inGap = false;
  List<int> gapY = [];
  for (int y = 0; y < image.height; y++) {
    bool isGap = true;
    for (int x = 0; x < image.width; x++) {
      if (image.getPixel(x, y).a > 0) {
        isGap = false;
        break;
      }
    }
    if (isGap && !inGap) {
      rowGaps++;
      inGap = true;
      gapY.add(y);
    } else if (!isGap) {
      inGap = false;
    }
  }
  
  // scan for blank columns
  int colGaps = 0;
  inGap = false;
  List<int> gapX = [];
  for (int x = 0; x < image.width; x++) {
    bool isGap = true;
    for (int y = 0; y < image.height; y++) {
      if (image.getPixel(x, y).a > 0) {
        isGap = false;
        break;
      }
    }
    if (isGap && !inGap) {
      colGaps++;
      inGap = true;
      gapX.add(x);
    } else if (!isGap) {
      inGap = false;
    }
  }
  
  print('Estimated columns: \${colGaps + 1}');
  print('Estimated rows: \${rowGaps + 1}');
  print('Gap X positions: \$gapX');
  print('Gap Y positions: \$gapY');
}
