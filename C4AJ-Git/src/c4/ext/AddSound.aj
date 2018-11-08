package c4.ext;

import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import c4.base.C4Dialog;

public privileged aspect AddSound {

	/** Directory where audio files are stored. */
	private static final String SOUND_DIR = "/sound/";

	pointcut playSound(C4Dialog dialog): 
		execution(* C4Dialog.makeMove(int)) && target(dialog);

	after(C4Dialog dialog) : playSound(dialog)  {
		if(!dialog.board.isWonBy(dialog.player)) {
			if(dialog.player.name() == "Red") {
				playAudio("user.au");
			}
			else {
				playAudio("computer.au");
			}	
		}
		else {
			playAudio("win.au");
		}
		if(dialog.board.isFull()) {
			playAudio("lose.au");
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



/*
 * pointcut discDropped(): execution(int Board.dropInSlot(int, Player));
 * 
 * after(): discDropped(){
 * System.out.println("disc dropped");
 * }
 * 
 * 
 * */