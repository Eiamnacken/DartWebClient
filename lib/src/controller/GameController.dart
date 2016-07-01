part of brickGame;
///
/// Gibt an wie oft sich der [Ball] in einem Zeitraum bewegt hier alle 250 millisekunden
///
const ballSpeed = const Duration(milliseconds: 100);

///
/// Wie oft bewegt sich ein [Item]
///
const itemSpeed = ballSpeed;

///
/// Wie oft wird der GameKey geprüft
///
const gameKeyCheck = const Duration(seconds: 1);

///
/// Serveradresse des GameKeyServers
///
const gameKeyHost = "";

const gameSecret = "c1b8f208-1e57-4431-bc7e-82f9db6e2780";

///
/// Portnummer des GameKeyServers
///
const gameKeyPort = 9000;

///
/// Ist verantwortlich für alle bewegungen
///
/// Durch aufrufen der einzelnen move Funktionen werden die Objekte im Spiel bewegt
/// Bei [Ball] und [Item] passiert dies über einen [Timer].
/// Der [Player] wird gesteuert über Listener im GameView.
///
class GameController {
  Game game = new Game();

  final View view = new View();

  GameKey gameKey = new GameKey("212.201.22.169", 50001);
///  GameKey gameKey = new GameKey("127.0.0.1",8080);

  Timer _ballTrigger;

  Timer _gameKeyTrigger;

  GameController() {
    try {
      this._gameKeyTrigger = new Timer.periodic(gameKeyCheck, (_) async {
        if (await this.gameKey.authenticate()) {
          view.warningoverlay.innerHtml = "";
        } else {
          view.warningoverlay.innerHtml =
          "Could not connect to gamekey service. "
              "Highscore will not working properly.";
        }
      });
    }catch (error, stacktrace) {
      print("GameController() caused following error: '$error'");
      print("$stacktrace");
      view.warningoverlay.innerHtml =
      "Could not get gamekey settings. "
          "Highscore will not working properly.";
    }


    view.startButton.onClick.listen((_) {
      if (_ballTrigger != null) _ballTrigger.cancel();
      if(game.won()||game.gameOver()) game = new Game();
      _ballTrigger = new Timer.periodic(ballSpeed, (_) => game.moveBall(this));
      view.generateField(game);
    });

    view.startGameButton.onClick.listen((_) {
      view.menuview.style.display = "none";
      view.gameview.style.display = "block";
    });

    view.backMenuButton.onClick.listen((_) {
      view.menuview.style.display = "block";
      view.gameview.style.display = "none";
    });

    view.helpButton.onClick.listen((_) {
      view.menuview.style.display = "none";
      view.help.style.display = "block";
    });

    view.cancelButton.onClick.listen((_) {
      view.menuview.style.display = "block";
      view.help.style.display = "none";
    });

    view.rightButton.onClick.listen((_) {
      if (game.gameOver()) return;
      game.movePLayer(Direction.right, this);
    });


    view.leftButton.onClick.listen((_) {
      if (game.gameOver()) return;
      game.movePLayer(Direction.left, this);
    });
    window.onKeyUp.listen((event) {
      if (game.gameOver()) return;
      if (event.keyCode == KeyCode.LEFT) {
        game.movePLayer(Direction.left, this);
      } else if (event.keyCode == KeyCode.RIGHT) {
        game.movePLayer(Direction.right, this);
      }
    });
    view.highscore.onClick.listen((_){
      gameKey.getStates().then((contetn)=>view.showHighscore(game,contetn));
    });

    view.generateField(game);
  }

  void updateView(List<List<GameObject>> gameField) {
    game.gameFields[game.countLevel].gameField=gameField;
    view.update(game);
  }
}
