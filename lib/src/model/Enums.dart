part of brickGame;

///
/// Gibt eine bewegungsrichtung an
///
enum Direction { leftUp, leftDown, rightUp, rightDown, up, down, left, right }

///
/// Liefert die x und y werte für eine übergebene [Direction] als map
///
/// Mit ["X"] bekommt man den x wert int int
/// Mit ["Y"] bekommt man den y wert in int
///
Map<String, int> getValuesForDirection(Direction direction) {
  int x = 0;
  int y = 0;
  switch (direction) {
    case Direction.down:
      y = -1;
      break;
    case Direction.up:
      y = 1;
      break;
    case Direction.rightDown:
      x = 1;
      y = -1;
      break;
    case Direction.rightUp:
      x = 1;
      y = 1;
      break;
    case Direction.leftDown:
      x = -1;
      y = -1;
      break;
    case Direction.leftUp:
      x = -1;
      y = 1;
      break;
    case Direction.left:
      x = -1;
      break;
    case Direction.right:
      x = 1;
      break;
  }
  return {"X": x, "Y": y==0?0:y*-1};
}

///
/// Die art der Effekte
///
enum Effect {
  ///
  /// Lässt den [Player] den der Spieler kontrolliert vergößern um einen Faktor
  /// in [Game] [_incLength] angegeben
  ///
  longerPLayer,

  ///
  /// Erhöht den Schaden den der [Ball] am [Brick] zufügt
  ///
  damageBall,

  ///
  /// Erstellt einen zweiten [Ball]
  ///
  secondBall,



  ///
  /// Invertiert die Steuerung des [Player]
  ///
  invertPlayer,

  ///
  /// Verkleinert den [Player] um den Faktor in [_decLength]
  ///
  smallerPlayer
}
///
/// Leben eines [Brick] [green] bedeutet noch 3 treffer [yellow] 2 und [red] 1
/// [grey] sind zerstörte [Brick]
/// [brown] sind unzerstörbare [Brick]
///
enum Health { grey, green, yellow, red, brown }

///
/// Umrechnung welchen [Health] ein objekt nach einem treffer bekommt
/// [damage] Schaden an dem Objekt
/// [health] Momentane lebenspunkte des Objekts
///
Health getHealth(int damage, Health health) {
  List values = Health.values;
  int index = health.index - damage;
  if (index <= 0) {
    return Health.grey;
  } else
    return values[index];
}

Health generateHealth(String health) {
  Health buffer;
  if (health == "green") {
    buffer = Health.green;
  } else if (health == "grey") {
    buffer = Health.grey;
  } else if (health == "yellow") {
    buffer = Health.yellow;
  } else if (health == "red") {
    buffer = Health.red;
  } else if (health == "brown") {
    buffer = Health.brown;
  }
  return buffer;
}
