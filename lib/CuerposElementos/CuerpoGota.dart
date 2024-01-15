import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:juego_clase_marcosgarcia/juegos/ClaseJuego.dart';
import '../elementos/Gota.dart';

class CuerpoGota extends BodyComponent<ClaseJuego> with ContactCallbacks {
  Vector2 posXY;
  Vector2 tamWH;
  double xIni = 0;
  double xFin = 0;
  double xContador = 0;
  double dAnimDireccion = -1;
  double dVelocidadAnim = 1;

  CuerpoGota({required this.posXY, required this.tamWH}) : super();

  @override
  Body createBody() {
    BodyDef bodyDef = BodyDef(
        type: BodyType.dynamic,
        position: posXY,
        gravityOverride: Vector2(0, 0));
    Body cuerpo = world.createBody(bodyDef);
    CircleShape shape = CircleShape();
    shape.radius = tamWH.x / 2;

    Fixture fix = cuerpo.createFixtureFromShape(shape);
    fix.userData = this;

    return cuerpo;
  }

  @override
  Future<void> onLoad() async {
    renderBody = false;
    await super.onLoad();

    Gota gotaPlayer = Gota(position: Vector2.all(-21), size: tamWH);
    add(gotaPlayer);

    xIni = posXY.x;
    xFin = (40);
    xContador = 0;
  }
}
