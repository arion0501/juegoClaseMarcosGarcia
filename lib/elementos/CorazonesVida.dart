import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:juego_clase_marcosgarcia/personajes/ClaseJugador.dart';

class CorazonesVida extends PositionComponent {
  final ClaseJugadorBody jugador;
  final double tamanoX, tamanoY;
  final double offsetX = 45.0;
  final double offsetY = 64.0;
  final double offsetXPaint = 101.25;
  final double offsetYPaint = 12.0;

  late final ui.Image heartImageFull;
  late final ui.Image heartImageHalf;

  CorazonesVida(this.jugador, this.tamanoX, this.tamanoY) {
    loadImages();
  }

  Future<void> loadImages() async {
    heartImageFull = await loadImage('assets/images/heart.png');
    heartImageHalf = await loadImage('assets/images/heart_half.png');
  }

  Future<ui.Image> loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(Uint8List.view(data.buffer));
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void render(Canvas c) {
    final heartSize = 32.0 * tamanoX;
    final spacing = 10.0;

    for (int i = 0; i < 3; i++) {
      final heartX = offsetX * tamanoX + i * (heartSize + spacing);
      final heartY = offsetY * tamanoY;

      final ui.Image heartImage = (i < jugador.iVidas) ? heartImageFull : heartImageHalf;
      c.drawImageRect(
        heartImage,
        Rect.fromPoints(Offset(0, 0), Offset(heartImage.width.toDouble(), heartImage.height.toDouble())),
        Rect.fromPoints(Offset(heartX, heartY), Offset(heartX + heartSize, heartY + heartSize)),
        Paint(),
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Vidas del jugador: ${jugador.iVidas}',
        style: TextStyle(color: Colors.black, fontSize: 48),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(c, Offset(offsetXPaint * tamanoX, offsetYPaint * tamanoY));
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.x = 0;
    this.y = 0;
  }
}
