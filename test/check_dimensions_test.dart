import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('print image size', () async {
    final bytes = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\ezgif.com-video-to-webp-converter.webp').readAsBytesSync();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    print('WEBP Size: \${frame.image.width} x \${frame.image.height}');
    
    final bytes2 = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\Cheering-ezgif.com-gif-to-sprite-converter.png').readAsBytesSync();
    final codec2 = await instantiateImageCodec(bytes2);
    final frame2 = await codec2.getNextFrame();
    print('PNG Size: \${frame2.image.width} x \${frame2.image.height}');
  });
}
