/*
 * Mauricio Roberto Hidalgo & Mark Nunez
 * Programming Assignment 2
 * AspectJ
 * CS3360 TR 10:30 - 11:50
 * 11/18/18
 */
package c4.ext;

import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import c4.base.C4Dialog;

/* Adds sounds to the Connect4. */
public privileged aspect AddSound {

	/* Directory where audio files are stored. */
	private static final String SOUND_DIR = "/sound/";

	/* Pointcut to play a sound every move depending the player and a win and draw sound 
	 * depending the case. 
	*/ 
	pointcut playSound(C4Dialog dialog): 
		execution(* C4Dialog.makeMove(int)) && target(dialog);
	
	/* Pointcut that blocks sound once a player won. */
	pointcut blockSound(C4Dialog dialog): 
		execution(* C4Dialog.makeMove(int)) && target(dialog);

	/* Plays a sound depending the player and case. */
	after(C4Dialog dialog) : playSound(dialog)  {
		if(!dialog.board.isWonBy(dialog.player)) {
			if(dialog.player.name() == "Red") {
				playAudio("Red.au");
			}
			else {
				playAudio("Blue.au");
			}	
		}
		else {
			playAudio("Win.au");
		}
		if(dialog.board.isFull() && !dialog.board.isWonBy(dialog.player)) {
			playAudio("Draw.au");
		}
	}
	
	/* Blocks sound once a player won. */
	void around(C4Dialog dialog) : blockSound(dialog)  {
		if(!dialog.board.isGameOver()) {
			proceed(dialog);
		}
	}

	/** Play the given audio file. */
	public static void playAudio(String filename) {
		try {
			AudioInputStream audioIn = AudioSystem.getAudioInputStream(
					AddSound.class.getResource(SOUND_DIR + filename));
			Clip clip = AudioSystem.getClip();
			clip.open(audioIn);
			clip.start();
		} catch (UnsupportedAudioFileException 
				| IOException | LineUnavailableException e) {
			e.printStackTrace();
		}
	}
}