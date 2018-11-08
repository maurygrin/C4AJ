package c4.ext;

import c4.base.ColorPlayer;
import c4.base.C4Dialog;

public privileged aspect EndGame{
	
	pointcut checkWin(C4Dialog dialog):
		execution(* C4Dialog.makeMove(int)) && target(dialog);
		
	private void C4Dialog.showWin(ColorPlayer opponent){		
		player = opponent;
		showMessage(player.name() + " Won!");
		repaint();
	}
	
	private void C4Dialog.showDraw(){
		showMessage("Draw!!");
		repaint();
	}
	
	after (C4Dialog dialog): checkWin(dialog){
		if(dialog.board.isWonBy(dialog.player)) {
			dialog.showWin(dialog.player);
		}
		if (dialog.player.name () == "Red") {
	//		
		}
		if(dialog.board.isFull()) {
			dialog.showDraw();
		}
		if(dialog.board.isGameOver()) {
		//	
		}
	}
}