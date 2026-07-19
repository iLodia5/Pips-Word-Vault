import 'dart:io';
import 'dart:typed_data';

void main() {
  var file = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\Cheering-ezgif.com-gif-to-sprite-converter.png');
  var bytes = file.readAsBytesSync();
  
  var byteData = ByteData.view(bytes.buffer);
  var width = byteData.getUint32(16, Endian.big);
  var height = byteData.getUint32(20, Endian.big);
  
  print('Width: ' + width.toString() + ', Height: ' + height.toString());
}
