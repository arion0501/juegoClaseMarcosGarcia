import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:juego_clase_marcosgarcia/CuerposElementos/CuerpoTierra.dart';
import '../CuerposElementos/CuerpoGota.dart';
import '../elementos/CorazonesVida.dart';
import '../elementos/Estrella.dart';
import '../personajes/ClaseJugador.dart';
import '../personajes/ClaseJugador2.dart';

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
  late ClaseJugadorBody2 _jugador2;
  late CorazonesVida corazonVida;
  //late CuerpoEnemigo _enemy;

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

    wScale = size.x / gameWidth;
    hScale = size.y / gameHeigth;

    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);

    mapComponent = await TiledComponent.load(
        'mapa1.tmx', Vector2(32 * wScale, 32 * hScale));
    add(mapComponent);

    void InicioContactosDelJuego(Object objeto, Contact contact) {
      if (objeto is CuerpoGota) {
        _ember.iVidas--;
        if (_ember.iVidas == 0) {
          _ember.removeFromParent();
        }
      }
    }

    ObjectGroup? estrellas =
    mapComponent.tileMap.getLayer<ObjectGroup>("estrellas");

    for (final estrella in estrellas!.objects) {
      Estrella spriteStar = Estrella(
          position: Vector2(estrella.x * wScale, estrella.y * hScale),
          size: Vector2(32 * wScale, 32 * hScale));
      add(spriteStar);
    }

    ObjectGroup? gotas = mapComponent.tileMap.getLayer<ObjectGroup>("gotas");

    for (final gota in gotas!.objects) {
      CuerpoGota gotaBody = CuerpoGota(
          posXY: Vector2(gota.x * wScale, gota.y * hScale),
          tamWH: Vector2(32 * wScale, 32 * hScale));
      add(gotaBody);
    }

    ObjectGroup? tierras = mapComponent.tileMap.getLayer<ObjectGroup>("tierra");

    for (final tiledObjectTierra in tierras!.objects) {
      CuerpoTierra tierraBody = CuerpoTierra(
          tiledBody: tiledObjectTierra, scales: Vector2(wScale, hScale));
      add(tierraBody);
    }

    _ember = ClaseJugadorBody(
        initialPosition: Vector2(200, canvasSize.y - canvasSize.y / 2),
        tamano: Vector2(64 * wScale, 64 * hScale));
    _ember.onBeginContact = InicioContactosDelJuego;
    add(_ember);

    corazonVida = CorazonesVida(_ember, wScale, hScale);
    add(corazonVida);

    _jugador2 = ClaseJugadorBody2(
        initialPosition: Vector2(210, canvasSize.y - canvasSize.y / 2),
        tamano: Vector2(64 * wScale, 64 * hScale));
    _ember.onBeginContact = InicioContactosDelJuego;
    add(_jugador2);

    /*_enemy = CuerpoEnemigo(
      posXY: Vector2(200, canvasSize.y - 280),
      tamWH: Vector2(64 * wScale, 64 * hScale),
    );
    world.add(_enemy);*/
  }
}