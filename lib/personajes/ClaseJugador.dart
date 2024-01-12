import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juego_clase_marcosgarcia/juegos/ClaseJuego.dart';

class ClaseJugador extends SpriteAnimationComponent
    with HasGameRef<ClaseJuego> {

  ClaseJugador({
    required super.position, required super.size
  }) : super( anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }
}

class ClaseJugadorBody extends BodyComponent
    with KeyboardHandler, ContactCallbacks {
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  late ClaseJugador emberPlayer;
  Vector2 initialPosition;

  ClaseJugadorBody(
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

    FixtureDef fixtureDef =
        FixtureDef(shape, restitution: 0.5, userData: this);
    cuerpo.createFixture(fixtureDef);

    return cuerpo;
  }

@override
Future<void> onLoad() {
  emberPlayer = ClaseJugador(position: Vector2(0,0), size: tamano);
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
    verticalDirection = 0;

    // ARRIBA DERECHA
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      horizontalDirection = 1;
      verticalDirection = -1;
    }
    // ARRIBA IZQUIERDA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      horizontalDirection = -1;
      verticalDirection = -1;
    }
    // ABAJO IZQUIERDA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      horizontalDirection = -1;
      verticalDirection = 1;
    }
    // ABAJO DERECHA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      horizontalDirection = 1;
      verticalDirection = 1;
    }
    // DERECHA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection = 1;
    }
    // IZQUIERDA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection = -1;
    }
    // ARRIBA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      verticalDirection = -1;
    }
    // ABAJO
    else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      verticalDirection = 1;
    } else {
      horizontalDirection = 0;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}