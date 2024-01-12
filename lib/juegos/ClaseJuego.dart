import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class ClaseJuego extends FlameGame with HasKeyboardHandlerComponents{
    ClaseJuego();

    late TiledComponent mapComponent;

    @override
    Future<void> onLoad() async {
        mapComponent = await TiledComponent.load('mapa1.tmx', Vector2.all(32));
        world.add(mapComponent);
    }
}