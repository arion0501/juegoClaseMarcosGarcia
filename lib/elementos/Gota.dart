import 'package:flame/components.dart';
import 'package:juego_clase_marcosgarcia/juegos/ClaseJuego.dart';

class Gota extends SpriteAnimationComponent with HasGameRef<ClaseJuego> {

  Gota({
    required super.position, required super.size
  }) :  super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        amountPerRow: 2,
        textureSize: Vector2(16, 16),
        stepTime: 0.12,
      ),
    );
  }
}