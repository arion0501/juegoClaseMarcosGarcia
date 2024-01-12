import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:juego_clase_marcosgarcia/elementos/CuerpoTierra.dart';
import '../elementos/Estrella.dart';
import '../elementos/Gota.dart';
import '../personajes/ClaseJugador.dart';

class ClaseJuego extends Forge2DGame with HasKeyboardHandlerComponents {

    ClaseJuego();

    double gameWidth = 1920;
    double gameHeigth = 1080;

    double wScale = 1.0;
    double hScale = 1.0;

    @override
    late final CameraComponent cameraComponent;
    late TiledComponent mapComponent;
    late ClaseJugadorBody _ember;

    @override
    Color backgroundColor() {
        return const Color.fromARGB(255, 173, 223, 247);
    }

    @override
    Future<void> onLoad() async {
        await images.loadAll([
            'ember.png',
            'heart_half.png',
            'heart.png',
            'star.png',
            'water_enemy.png',
            'mapa1.png',
            'mapa2.png'
        ]);

        wScale = size.x/gameWidth;
        hScale = size.y/gameHeigth;

        cameraComponent = CameraComponent(world: world);
        cameraComponent.viewfinder.anchor = Anchor.topLeft;
        addAll([cameraComponent, world]);

        mapComponent = await TiledComponent.load('mapa1.tmx', Vector2(32 * wScale, 32 * hScale));
        world.add(mapComponent);

        ObjectGroup? estrellas = mapComponent.tileMap.getLayer<ObjectGroup>("estrellas");

        for(final estrella in estrellas!.objects) {
            Estrella spriteStar = Estrella(position: Vector2(estrella.x * wScale, estrella.y * hScale), size: Vector2(32 * wScale, 32 * hScale));
            world.add(spriteStar);
        }

        ObjectGroup? gotas = mapComponent.tileMap.getLayer<ObjectGroup>("gotas");

        for(final gota in gotas!.objects) {
            Gota spriteGota = Gota(position: Vector2(gota.x * wScale, gota.y * hScale), size: Vector2(32 * wScale, 32 * hScale));
            world.add(spriteGota);
        }

        ObjectGroup? tierras = mapComponent.tileMap.getLayer<ObjectGroup>("tierra");

        for(final tiledObjectTierra in tierras!.objects){
            CuerpoTierra tierraBody = CuerpoTierra(tiledBody: tiledObjectTierra,
                scales: Vector2(wScale, hScale));
            add(tierraBody);
        }

        _ember = ClaseJugadorBody(
            initialPosition: Vector2(64, 64), tamano: Vector2(64 * wScale, 64 * hScale)
        );

        world.add(_ember);
    }
}