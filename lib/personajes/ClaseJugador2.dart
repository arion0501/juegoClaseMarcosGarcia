import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../juegos/ClaseJuego.dart';

class ClaseJugador2 extends SpriteAnimationComponent
    with HasGameRef<ClaseJuego> {
  ClaseJugador2({required super.position, required super.size})
      : super(anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        amountPerRow: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }
}

class ClaseJugadorBody2 extends BodyComponent
    with KeyboardHandler, ContactCallbacks {
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  late ClaseJugador2 emberPlayer;
  Vector2 initialPosition;
  bool blEspacioLiberado = true;
  int iVidas = 3;

  ClaseJugadorBody2(
      {required this.initialPosition, required, required this.tamano})
      : super();

  @override
  Body createBody() {
    BodyDef definicionCuerpo = BodyDef(
        position: initialPosition,
        type: BodyType.dynamic,
        angularDamping: 0.8,
        userData: this);

    Body cuerpo = world.createBody(definicionCuerpo);

    final shape = CircleShape();
    shape.radius = tamano.x / 2;

    FixtureDef fixtureDef = FixtureDef(shape, restitution: 0.5, userData: this);
    cuerpo.createFixture(fixtureDef);

    return cuerpo;
  }

  @override
  Future<void> onLoad() {
    emberPlayer = ClaseJugador2(position: Vector2(0, 0), size: tamano);
    add(emberPlayer);
    return super.onLoad();
  }

  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  void update(double dt) {
    velocidad.x = horizontalDirection * aceleracion;
    velocidad.y = verticalDirection * aceleracion;

    initialPosition += velocidad * dt;
    body.applyLinearImpulse(velocidad * dt * 1000);

    if (horizontalDirection < 0 && emberPlayer.scale.x > 0) {
      emberPlayer.flipHorizontallyAroundCenter();
    } else if (horizontalDirection > 0 && emberPlayer.scale.x < 0) {
      emberPlayer.flipHorizontallyAroundCenter();
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;

    final bool isKeyDown = event is RawKeyDownEvent;
    final bool isKeyUp = event is RawKeyUpEvent;

    if (keysPressed.contains(LogicalKeyboardKey.numpad4) &&
        keysPressed.contains(LogicalKeyboardKey.numpad2)) {
      horizontalDirection = -1;
      verticalDirection = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad6) &&
        keysPressed.contains(LogicalKeyboardKey.numpad2)) {
      horizontalDirection = 1;
      verticalDirection = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad6) &&
        keysPressed.contains(LogicalKeyboardKey.numpad8)) {
      horizontalDirection = 1;
      verticalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad4) &&
        keysPressed.contains(LogicalKeyboardKey.numpad8)) {
      horizontalDirection = -1;
      verticalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad6)) {
      horizontalDirection = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad4)) {
      horizontalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad2)) {
      verticalDirection = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.numpad8)) {
      verticalDirection = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.numpad5)) {
      if (blEspacioLiberado) {
        blEspacioLiberado = false;
        body.gravityOverride = Vector2(0, -40);
      }
    } else if (isKeyUp) {
      blEspacioLiberado = true;
      body.gravityOverride = Vector2(0, 40);
    }
    return true;
  }
}
