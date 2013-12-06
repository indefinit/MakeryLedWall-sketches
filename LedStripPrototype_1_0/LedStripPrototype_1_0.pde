/**
 * First prototype simulation of LED color strip for Makery Wall.
 * v.1.0.0
 * @author: StudioIndefinit
 * @date: 12/3/13
 */
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fftLin;
FFT fftLog;
float spectrumScale = 4; // scaling value for our spectrum

Strip strip;
int ledN = 60; //change this to increase | decrease number of leds


void setup(){
  size(512, 512);
  background(255);
  
  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  
  // uncomment this line to *hear* what is being monitored, in addition to seeing it
  in.enableMonitoring();
  
  // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // see the online tutorial for more info.
  fftLin = new FFT( in.bufferSize(), in.sampleRate() );
  
  // calculate the averages by grouping frequency bands linearly. set to same number as LEDS in Strip
  fftLin.linAverages(ledN); 
  
  /**
   * Strip
   * @params:
   *   1. number of leds in strip
   *   2. strip position x
   *   3. strip position y
   *   4. strip width
   */
  strip = new Strip(ledN, 20, (height/2)-20, width-40);  
  int grayscaleCol = 0; // hack this line to change the led colors
  
  for (int i = 0; i<strip.size; i++){ // loop through our led strip
    strip.getLed(i).setLedColor(color(grayscaleCol += 4)); // +=1 degrades grayscale value over loop
  }
}

void draw(){
  fftLin.forward( in.left );
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < fftLin.avgSize(); i++){
    println(int(map(fftLin.getAvg(i), 0, 10, 0, 255)));
  }
  
  strip.display(); 
  
}
