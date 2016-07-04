part of brickGame;

///
/// Ein [Level] ist ein Level im Spiel
///
/// Enthält alle [Brick] die zuvor generiert wurden. Diese werden aus der Config
/// generiert die in [_readLevel] übergeben werden vom Constructor
///
class Level {
  ///
  /// Breite des Spielfelds
  ///
  int _height;

  ///
  /// Länge des Spielfelds
  ///
  int _length;

  ///
  /// Anzahl der positiven [Item] die dieses Level enthält
  ///
  int _countPositiveItems;



  ///
  /// Enthält das gesamte Spielfeld als 2d Liste
  ///
  /// Felder ohne ein relevantes Objekt enthalten einfach nur die Oberklasse
  /// [GameObject] andere Felder haben dementsprechend [Ball],[Brick],[Item]
  /// oder [Player]
  ///
  List<List<GameObject>> _gameField;

  Player _player;

  List<Ball> balls;

  List<Item> items;

  List<Brick> bricks;

  Level() {
    balls = new List();
    items = new List();
    bricks = new List();
  }

  ///
  /// Generiert das Level aus der übergebenen [config]
  ///
  void readLevel(String config) {
    int playerHeight,
        playerLength,
        brickHeight,
        brickLength,
        ballHeight,
        ballLength,
        ballSpeed,
        playerSpeed,
        itemSpeed;

    Map jsonLevel = JSON.decode(config);
    _height = int.parse(jsonLevel['levelHeight'].toString());
    _length = int.parse(jsonLevel['levelLength'].toString());
    _countPositiveItems = int.parse(jsonLevel['countPosItems'].toString());
    playerHeight = int.parse(jsonLevel['playerHeight'].toString());
    playerLength = int.parse(jsonLevel['playerLength'].toString());
    brickHeight = int.parse(jsonLevel['brickHeight'].toString());
    brickLength = int.parse(jsonLevel['brickLength'].toString());
    ballHeight = int.parse(jsonLevel['ballHeight'].toString());
    ballLength = int.parse(jsonLevel['ballLength'].toString());
    ballSpeed = int.parse(jsonLevel['ballSpeed'].toString());
    playerSpeed = int.parse(jsonLevel['playerSpeed'].toString());
    //itemSpeed = int.parse(jsonLevel['itemSpeed'].toString());

    // level field from the json file (only contains strings like 'redbrick' or 'player')
    List<List<String>> jsonField = jsonLevel['levelField'];
    _gameField = new Iterable.generate(_length, (col) {
      return new Iterable.generate(_height, (row) => null).toList();
    }).toList();

    for (int row = 0; row < jsonField.length; row++) {
      for (int col = 0; col < jsonField[row].length; col++) {
        if (jsonField[row][col].compareTo('e') == 0) {
          _gameField[col][row] = new Field(col, row, brickLength, brickHeight);
        } else if (jsonField[row][col].compareTo('item') ==
            0) {} else if (jsonField[row][col].compareTo('ball') == 0) {
          Ball ball = new Ball(col, row, ballHeight, ballLength, ballSpeed);
          ball.activated = true;
          _gameField[col][row] = ball;
          balls.add(ball);
        } else if (jsonField[row][col].compareTo('player') == 0) {
          _player =
              new Player(col, row, playerLength, playerHeight, playerSpeed);
          _gameField[col][row] = player;
        } else {
          Brick newBrick = new Brick(
              col, row, brickLength, brickHeight, jsonField[row][col]);
          _gameField[col][row] = newBrick;
          bricks.add(newBrick);
        }
      }
    }
    //Aktiviere Items an einer random stelle
    if (_countPositiveItems != 0) {
      Random randomNumber = new Random.secure();
      int counter = _countPositiveItems;
      List<Ball> itemBalls = [];
      Ball ballBuffer = balls.first;
      Direction ballDirection;
      while (counter != 0) {
        Brick objectBuffer = bricks[randomNumber.nextInt(bricks.length )];

        if (objectBuffer._item == null) {
          for (int i = 0; i < 3; i++) {
            ballDirection=Direction.values[randomNumber.nextInt(5)];
            Ball itemBall = new Ball.withDirection(
                objectBuffer.xPosition,
                objectBuffer.yPosition,
                ballBuffer.height,
                ballBuffer.width,
                ballBuffer._moveSpeed,
                ballDirection
                );
            itemBalls.add(itemBall);
            balls.add(itemBall);
          }
          objectBuffer._item = new Item.withBall(
              objectBuffer.xPosition,
              objectBuffer.yPosition,
              brickHeight,
              brickLength,
              itemSpeed,
              Effect.secondBall,
              itemBalls);
          counter--;
        }
      }
    }
  }

  Player get player => _player;

  List<List<GameObject>> get gameField => _gameField;
  set gameField(List<List<GameObject>> gameField) => _gameField = gameField;
}
