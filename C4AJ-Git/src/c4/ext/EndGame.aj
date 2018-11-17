/*
 * Mauricio Roberto Hidalgo & Mark Nunez
 * Programming Assignment 2
 * AspectJ
 * CS3360 TR 10:30 - 11:50
 * 11/18/18
 */
package c4.ext;

import c4.base.ColorPlayer;
import c4.base.C4Dialog;

/* Ends Connect4 game. */
public privileged aspect EndGame extends AddOpponent{

	/* Pointcut that checks if a player won or if is draw */
	pointcut checkWin(C4Dialog dialog):
		execution(* C4Dialog.makeMove(int)) && target(dialog);

	/* Pointcut that starts a new game and reset players. */
	pointcut newGame(C4Dialog dialog): 
		execution(* C4Dialog.newButtonClicked(*)) && target(dialog);

	/* Pointcut that blocks moves once a player won. */
	pointcut blockPlayers(C4Dialog dialog): 
		execution(* C4Dialog.makeMove(int)) && target(dialog);

	/* Shows who won in C4Dialog. */
	private void C4Dialog.showWin(ColorPlayer opponent){		
		player = opponent;
		showMessage(player.name() + " Won!");
	}

	/* Shows draw in C4Dialog. */
	private void C4Dialog.showDraw(){
		showMessage("Draw!!");
	}

	/* Checks if a player won or if is draw */
	after (C4Dialog dialog): checkWin(dialog){
		if(dialog.board.isWonBy(dialog.player)) {
			dialog.showWin(dialog.player);
		}
		if(dialog.board.isFull() && !dialog.board.isWonBy(dialog.player)) {
			dialog.showDraw();
		}
	}

	/* Starts a new game and reset players. */
	void around(C4Dialog dialog) : newGame(dialog)  {
		if(dialog.player.name() == "Red") {
			dialog.changeTurn(players.get(2));		
		}
		dialog.startNewGame();
	}
	
	/* Blocks moves once a player won. */
	void around(C4Dialog dialog) : blockPlayers(dialog)  {
		if(dialog.board.isGameOver()) {
			dialog.showWin(dialog.player);
		}
		else {
			proceed(dialog);
		}
	}
}