package c4.ext;

import java.util.Arrays;
import java.util.List;
import java.awt.Color;
import c4.base.ColorPlayer;
import c4.base.C4Dialog;
import c4.base.BoardPanel;

public privileged aspect AddOpponent{

	private List<ColorPlayer> players;

	private BoardPanel C4Dialog.boardPanel;

	static int counter = 1;

	pointcut changePlayers(C4Dialog dialog): 
		execution(* C4Dialog.makeMove(int)) && target(dialog);

	private void C4Dialog.changeTurn(ColorPlayer opponent) {
		player = opponent;
		boardPanel.setDropColor(player.color());
		showMessage(player.name() + "'s turn.");
		repaint();
	}

	before(C4Dialog dialog):
		this(dialog) && execution(void C4Dialog.configureUI()){
		players = Arrays.asList(dialog.player, 
				new ColorPlayer("Red", Color.RED), dialog.player, 
				new ColorPlayer("Blue", Color.BLUE));
	}

	after(C4Dialog dialog) returning (BoardPanel panel):
		this(dialog) && call(BoardPanel.new(..)){
		dialog.boardPanel = panel;
	}

	after(C4Dialog dialog) : changePlayers(dialog)  {
		if(counter % 2 == 0) {
			dialog.changeTurn(players.get(2));
			counter++;
		}
		else {
			dialog.changeTurn(players.get(1));
			counter++;
		}	
	}
}