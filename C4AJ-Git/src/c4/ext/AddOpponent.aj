/*
 * Mauricio Roberto Hidalgo & Mark Nunez
 * Programming Assignment 2
 * AspectJ
 * CS3360 TR 10:30 - 11:50
 * 11/18/18
 */
package c4.ext;

import java.util.Arrays;
import java.util.List;
import java.awt.Color;
import c4.base.ColorPlayer;
import c4.base.C4Dialog;
import c4.base.BoardPanel;

/* Adds an opponent to the Connect4. */
public abstract privileged aspect AddOpponent{

	/* List that contains both players. */
	private List<ColorPlayer> players;

	/* Instance that contains BoardPanel from C4Dialog. */
	private BoardPanel C4Dialog.bp;

	/* Pointcut that changes the players when a player makes a move. */
	pointcut changePlayers(C4Dialog dialog): 
		execution(* C4Dialog.makeMove(int)) && target(dialog);

	/* Changes turn in C4Dialog. */
	private void C4Dialog.changeTurn(ColorPlayer opponent) {
		player = opponent;
		bp.setDropColor(player.color());
		showMessage(player.name() + "'s turn.");
	}

	/* Initializes both players when the UI is configured. */
	before(C4Dialog dialog):
		this(dialog) && execution(void C4Dialog.configureUI()){
		players = Arrays.asList(dialog.player, 
				new ColorPlayer("Red", Color.RED), dialog.player, 
				new ColorPlayer("Blue", Color.BLUE));
	}

	/* Initializes new BoardPanel in C4Dialog. */
	after(C4Dialog dialog) returning (BoardPanel panel):
		this(dialog) && call(BoardPanel.new(..)){
		dialog.bp = panel;
	}

	/* Change turns depending what player did a move. */
	after(C4Dialog dialog) : changePlayers(dialog)  {
		if(!dialog.board.isWonBy(dialog.player)) {
			if(dialog.player.name() == "Blue") {
				dialog.changeTurn(players.get(1));
			}
			else {
				dialog.changeTurn(players.get(2));
			}	
		}
	}
}