/*
 * Mauricio Roberto Hidalgo & Mark Nunez
 * Programming Assignment 2
 * AspectJ
 * CS3360 TR 10:30 - 11:50
 * 11/18/18
 */
package c4.ext;

import java.awt.event.MouseEvent;
import c4.base.BoardPanel;
import java.awt.Graphics;
import java.awt.Color;
import java.awt.event.*;

/* Adds an animation on the discs of the Connect4. */
public privileged aspect pressDisc {

	/* A variable in BoardPanel with the slot pressed. */
	private int BoardPanel.mouseSlot = -1;

	/* Pointcut that set mouseSlot to the clicked slot. */
	pointcut press(BoardPanel bp):
		execution(BoardPanel.new(..)) && this(bp);
	
	/* Pointcut that draws a different disc depending the clicked slot. */
	pointcut drawDisc(BoardPanel bp, Graphics g):
		execution(void BoardPanel.drawDroppableCheckers(Graphics)) && this(bp) && args(g);

	/* Sets mouseSlot to the clicked slot. */
	after(BoardPanel bp) : press(bp){
		bp.addMouseListener(new MouseAdapter() {
			public void mousePressed(MouseEvent e) {
				if(!bp.board.isGameOver()) {
					bp.mouseSlot = bp.locateSlot(e.getX(),e.getY());
					bp.repaint();
				}
			}
		});
		bp.addMouseListener(new MouseAdapter() {
			public void mouseReleased(MouseEvent e) {
				if(!bp.board.isGameOver()) {
					bp.mouseSlot = -1;
					bp.repaint();
				}
			}
		});
	}

	/* Draws a different disc depending which one was pressed and also highlights it. */
	after(BoardPanel bp, Graphics g):drawDisc(bp,g){
		if(bp.mouseSlot >= 0 && !bp.board.isSlotFull(bp.mouseSlot)) {
			bp.drawChecker(g, bp.dropColor, bp.mouseSlot, -1, -1);
			bp.drawChecker(g, Color.GREEN, bp.mouseSlot, -1, 5);
		}
	}
}