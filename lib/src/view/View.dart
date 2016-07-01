part of brickGame;

class View {
  final warningoverlay = querySelector("#warningoverlay");

  final title = querySelector("#title");

  final level = querySelector("#level");

  final gameover = querySelector("#gameover");

  final game = querySelector("#game");

  final points = querySelector("#points");

  final highscore = querySelector("#score");

  final menuview = querySelector("#menuview");

  final gameview = querySelector("#gameview");

  final welcome = querySelector("#welcome");

  final overlay = querySelector("#overlay");

  final back = querySelector("#back");

  final help = querySelector("#help");

  final vanishedButton = querySelector("#button");

  HtmlElement get startGameButton => querySelector("#startgame");

  HtmlElement get startButton => querySelector("#start");

  HtmlElement get backMenuButton => querySelector("#backmenu");

  HtmlElement get helpButton => querySelector("#howto");

  HtmlElement get cancelButton => querySelector("#cancelbutton");

  HtmlElement get rightButton => querySelector("#rightbutton");

  HtmlElement get leftButton => querySelector("#leftbutton");

  List<List<HtmlElement>> gameFields;


  void generateField(Game model) {
    final List<List<GameObject>> field = model.gameFields[model.countLevel]
        .gameField;

    String table = "";

    for (int row = 0; row < field[0].length; row++) {
      table += "<tr>";
      for (int col = 0; col < field.length; col++) {
        final assignment = field[col][row].toString();
        final pos = "field_${col}_${row}";
        table +=
        "<td id='$pos' class='$assignment'  ></td>";
      }
      table += "</tr>";
    }
    game.innerHtml = table;

    gameFields = new List<List<HtmlElement>>(field.length);
    for (int row = 0; row < field.length; row++) {
      gameFields[row] = [];
      for (int col = 0; col < field[row].length; col++) {
        gameFields[row].add(game.querySelector("#field_${row}_${col}"));
        _setWidthAndLength(gameFields[row][col],field[row][col]);

      }
    }
  }

  void update(Game model, {List<Map> scores: const []}) {
    gameover.innerHtml = model.gameOver() ? "Game Over" : "";

    welcome.style.display = model.gameOver() ? "block" : "none";
    back.style.display = model.gameOver() ? "block" : "none";
    vanishedButton.style.display = model.gameOver() ? "none" : "block";


    level.innerHtml="Level: ${model.countLevel + 1}";
    highscore.innerHtml = model.gameOver() ? generateHighscore(scores) : "";
    points.innerHtml = "Points: ${model.points}";

    // Updates the field
    final field = model.gameFields[model.countLevel].gameField;

    for (int row = 0; row < field.length; row++) {
      for (int col = 0; col < field[row].length; col++) {
        var td = gameFields[row][col];
        td.classes.clear();
        GameObject object = field[row][col];
        td.classes.add(object.toString());
        td = _setWidthAndLength(td,object);

      }
    }
  }

  HtmlElement _setWidthAndLength(HtmlElement element,GameObject gameObject){
    if(element==null|| gameObject==null) return null;
    var width = gameObject.width;
    if(gameObject is Player){
      width = (gameObject.width/3);
      element.style..setProperty("padding-right","${width}px")
        ..setProperty("padding-left","${width}px")
        ..setProperty("width","${width}px")
        ..setProperty("height","${gameObject.height}px");
    }else{
      element.style..setProperty("width","${width}px")
        ..setProperty("height","${gameObject.height}px")
            ..setProperty("padding-right","0px")
        ..setProperty("padding-left","0px");
    }
    return element;

  }

  closeForm() => overlay.innerHtml = "";

  void warning(String message) {
    document
        .querySelector('#warningoverlay')
        .innerHtml = message;
  }

  String generateHighscore(List<Map> scores, { int score: 0 }) {
    final list = scores.map((entry) => "<li>${entry['name']}: ${entry['score']}</li>").join("");
    final points = "You got $score points";
    return "<div id='scorelist'>${ score == 0 ? "" : points }${ list.isEmpty? "" : "<ul>$list</ul>"}</div>";
  }

  void showHighscore(Game model, List<Map> scores) {

    if (overlay.innerHtml != "") return;
    final score = model.points;

    overlay.innerHtml =
    "<div id='highscore'>"
        "   <h1>Highscore</h1>"
        "</div>"
        "<div id='highscorewarning'></div>";

    if (scores.isEmpty || score > scores.last['score'] || scores.length < 10) {
      overlay.appendHtml(
          this.generateHighscore(scores, score: score) +
              "<form id='highscoreform'>"
                  "<input type='text' id='user' placeholder='user'>"
                  "<input type='password' id='password' placeholder='password'>"
                  "<button type='button' id='save'>Save</button>"
                  "<button type='button' id='close' class='discard'>Close</button>"
                  "</form>"
      );
    } else {
      overlay.appendHtml(this.generateHighscore(scores, score: score));
      overlay.appendHtml("<button type='button' id='close' class='discard'>Close</button>");
    }

  }

  /**
   * Gets the user input from the highscore form.
   */
  String get user => (document.querySelector('#user') as InputElement).value;

  /**
   * Gets the password input from the highscore form.
   */
  String get password => (document.querySelector('#password') as InputElement).value;

}
