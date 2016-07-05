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
const gameKeyCheck = const Duration(seconds: 3);

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
      _gameKeyTrigger = new Timer.periodic(gameKeyCheck, (_) async {
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
      _ballTrigger = new Timer.periodic(ballSpeed, (_)=> game.moveBall(this));
      newGame();
    });

    view.startGameButton.onClick.listen((_) {
      view.menuView.style.display = "none";
      view.gameView.style.display = "block";
    });

    view.backMenuButton.onClick.listen((_) {
      view.menuView.style.display = "block";
      view.gameView.style.display = "none";
    });

    view.helpButton.onClick.listen((_) {
      view.menuView.style.display = "none";
      view.help.style.display = "block";
    });

    view.cancelButton.onClick.listen((_) {
      view.menuView.style.display = "block";
      view.help.style.display = "none";
    });

    /*
    view.closeButton.onClick.listen((_){
      view.closeForm();
    }); */

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
      gameKey.getStates().then((contetn){
        view.showHighscore(game,contetn);
        // Handle cancel button
        document.querySelector('#close')?.onClick?.listen((_){
          view.closeForm();
          document.querySelector('#title').innerHtml='Brick Break';
        });
      });
    });

    view.generateField(game);
  }

  void resetGame(){
    game = new Game();
  }

  //Erstellt ein neues Spiel
  void newGame(){
    view.closeForm();
    view.generateField(game);
  }

  void updateView(List<List<GameObject>> gameField) {
    game.gameFields[game.countLevel].gameField=gameField;
    if((game.gameOver()||game.gameEnds())){
      _gameOver();
    }else{
      view.update(game);
    }
  }




  /**
   * Handles Game Over.
   */
  dynamic _gameOver() async {
    _ballTrigger.cancel();
    view.update(game);

    // Show TOP 10 Highscore
    final List<Map> highscore = await gameKey.getStates();
    view.showHighscore(game, highscore);

    // Handle save button
    document.querySelector('#save')?.onClick?.listen((_) async {

      String user = view.user;
      String pwd  = view.password;
      if (user?.isEmpty) { view.highscoreMessage("Please provide user name."); return;}

      String id = await gameKey.getUserId(user);
      if (id == null) {
        view.highscoreMessage(
            "User $user not found. Shall we create it?"
                "<button id='create'>Create</button>"
                "<button id='cancel' class='discard'>Cancel</button>"
        );
        document.querySelector('#cancel')?.onClick?.listen((_) => newGame());
        document.querySelector('#create')?.onClick?.listen((_) async {
          final usr = await gameKey.registerUser(user, pwd);
          if (usr == null) {
            view.highscoreMessage(
                "Could not register user $user. "
                    "User might already exist or gamekey service not available."
            );
            return;
          }
          view.highscoreMessage("");
          final stored = await gameKey.storeState(usr['id'], {
            'version': '0.0.2',
            'points': game.points
          });
          if (stored) {
            view.highscoreMessage("${game.points} points stored for $user");
            newGame();
            return;
          } else {
            view.highscoreMessage("Could not save highscore. Retry?");
            return;
          }
        });
      }

      // User exists.
      if (id != null) {
        final user = await gameKey.getUser(id, pwd);
        if (user == null) { view.highscoreMessage("Wrong access credentials."); return; };
        final stored = await gameKey.storeState(user['id'], {
          'version': '0.0.2',
          'points': game.points
        });
        if (stored) {
          view.highscoreMessage("${game.points} points stored for ${user['name']}");
          return;
        } else {
          view.highscoreMessage("Could not save highscore. Retry?");
          return;
        }
      }
    });

    // Handle cancel button
    document.querySelector('#close')?.onClick?.listen((_){
      resetGame();
      view.closeForm();
    });
    document.querySelector('#title').innerHtml='';
  }
}
