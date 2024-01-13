import 'package:flame/components.dart';
import '../juegos/ClaseJuego.dart';

class ClaseEnemigo extends SpriteAnimationComponent
    with HasGameRef<ClaseJuego> {
  ClaseEnemigo({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }
}