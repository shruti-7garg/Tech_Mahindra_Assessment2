import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 28, 129, 211),
          centerTitle: true,
          title: Text(
            'TIC TAC TOE GAME',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                PlayerPanel(),
                SizedBox(height: 40),
                GameGrid(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class PlayerPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Color.fromARGB(255, 28, 129, 211),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerNamePanel('Shruti', 'X'),
            Text(
              'TIC TAC TOE',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PlayerNamePanel('Garg', 'O'),
          ],
        ),
      ),
    );
  }
}

class PlayerNamePanel extends StatefulWidget {
  final String initialName;
  final String initialSymbol;

  PlayerNamePanel(this.initialName, this.initialSymbol);

  @override
  State<PlayerNamePanel> createState() {
    return PlayerNamePanelState();
  }
}

class PlayerNamePanelState extends State<PlayerNamePanel> {
  late String playerName;
  String buttonText = "edit";
  late String playerSymbol;

  TextEditingController textController = TextEditingController();

  @override
  initState() {
    super.initState();
    playerName = widget.initialName;
    playerSymbol = widget.initialSymbol;
  }

  onEditName() {
    setState(() {
      if (buttonText == 'edit') {
        buttonText = 'save';
        textController.text = playerName;
      } else {
        playerName = textController.text;
        buttonText = 'edit';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: 130,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color.fromARGB(255, 28, 129, 211),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buttonText == "edit"
                ? Text(
                  playerName,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    border: OutlineInputBorder(),
                  ),
                ),
            Text(
              playerSymbol,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 131, 192, 242),
              ),
              onPressed: onEditName,
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameGrid extends StatefulWidget {
  @override
  State<GameGrid> createState() => GameGridState();
}

class GameGridState extends State<GameGrid> {
  List<String> gameState = List.filled(9, "");
  String turnSymbol = 'X';
  String turnText = "Turn: X";
  bool gameOver = false;

  void onGameGridButtonClick(int index) {
    if (gameOver || gameState[index] != "") return;

    setState(() {
      gameState[index] = turnSymbol;
      String result = checkWin();

      if (result == 'WIN') {
        turnText = "WIN: $turnSymbol";
        gameOver = true;
      } else if (result == 'DRAW') {
        turnText = "DRAW";
        gameOver = true;
      } else {
        turnSymbol = (turnSymbol == 'X') ? 'O' : 'X';
        turnText = "Turn: $turnSymbol";
      }
    });
  }

  String checkWin() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (gameState[condition[0]] == turnSymbol &&
          gameState[condition[1]] == turnSymbol &&
          gameState[condition[2]] == turnSymbol) {
        return 'WIN';
      }
    }

    if (!gameState.contains("")) {
      return 'DRAW';
    }

    return 'GAMEON';
  }

  Widget buildButton(int index) {
    return Container(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 100,
        height: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 28, 129, 211),
            foregroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => onGameGridButtonClick(index),
          child: Text(
            gameState[index],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void resetGame() {
    setState(() {
      gameState = List.filled(9, "");
      turnSymbol = 'X';
      turnText = "Turn: X";
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          turnText,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 28, 129, 211),
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildButton(0), buildButton(1), buildButton(2)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildButton(3), buildButton(4), buildButton(5)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildButton(6), buildButton(7), buildButton(8)],
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: resetGame,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: Text(
            "Restart",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
