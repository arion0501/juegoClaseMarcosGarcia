import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'juegos/ClaseJuego.dart';

void main() {
  runApp(
    const GameWidget<ClaseJuego>.controlled(
      gameFactory: ClaseJuego.new,
    ),
  );
}