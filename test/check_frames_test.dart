import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;

void main() {
  test('print image frames', () async {
    final bytes = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\ezgif.com-video-to-webp-converter.webp').readAsBytesSync();
    final codec = await ui.instantiateImageCodec(bytes);
    print('WEBP Frame Count: \${codec.frameCount}');
    
    // Also let's check the size of the sprite sheet
    final bytes2 = File(r'C:\Users\BestTech\Documents\antigravity-projects\stitch_pip_s_word_vault\pip_word_vault\assets\images\Cheering-ezgif.com-gif-to-sprite-converter.png').readAsBytesSync();
    final codec2 = await ui.instantiateImageCodec(bytes2);
    final frame = await codec2.getNextFrame();
    print('Sprite width: \${frame.image.width}, height: \${frame.image.height}');
  });
}
