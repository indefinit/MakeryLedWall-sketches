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
int spectrumScale = 4; // scaling value for our spectrum

int r,g,b;
color ledColor = color(255,255,255,100); //default led color unless otherwise set

Strip strip;
Strip fireballStrip;

int ledN = 60; //change this to increase | decrease number of leds
int location = 0; //led location index in strip.  Used for determining curr position.

void setup(){
  size(1024, 512);
  background(255);
  
  minim = new Minim(this);
  in = minim.getLineIn();// use the getLineIn method of the Minim object to get an AudioInput
  
  // uncomment this line to *hear* what is being monitored, in addition to seeing it
  //in.enableMonitoring();
  
  // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // see the online tutorial for more info.
  fftLin = new FFT( in.bufferSize(), in.sampleRate() );
  
  // calculate the averages by grouping frequency bands linearly. set to double the LEDs in strip
  fftLin.linAverages(ledN*2);


  // create an FFT object for calculating logarithmically spaced averages
  fftLog = new FFT( in.bufferSize(), in.sampleRate() );
  
  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into three bands
  // this should result in 60 averages
  fftLog.logAverages( 22, 6 ); 
  
  /**
   * Strip
   * @params:
   *   1. number of leds in strip
   *   2. strip position x
   *   3. strip position y
   *   4. strip width
   */
  strip = new Strip(ledN, 20, (height/2)-20, width-40);  
  fireballStrip = new Strip(ledN, 20, (height/2)-100, width-40);
  
  
}

void draw(){
  
  float centerFrequency = 0;

  fftLin.forward( in.left );
  fftLog.forward(in.left);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < fftLog.avgSize(); i++){
    centerFrequency    = fftLog.getAverageCenterFrequency(i);
    int fftLogBucket = int(map(fftLog.getAvg(i), 0, 10, 0, 255));
    int fftLinBucket = int(map(fftLin.getAvg(i), 0, 10, 0, 255));
    // Uncomment this to do linear averaging
    //strip.getLed(i-60).setLedColor(pitchToColor(fftLinBucket));
    strip.getLed(i).setLedColor(pitchToColor(fftLogBucket));
  }
  //display our frequency spectrum strip
  strip.display(); 
  
  /////////////////////////////////////////////////////////////////
  /// Fireball strip 
  /// @TODO need to do something with boundary vector and write an applyForce(PVector posVect) method.
  // if (location > ledN-1){
  //   PVector boundary = new PVector(1,0);
  //   fireballStrip.applyForce(boundary);
  //   fireballStrip.getLed(location+1).setLedColor(pitchToColor(fftLogBucket));    
  // }
  // else if (location < ledN-1){
  //   PVector boundary = new PVector(1,0);
  //   fireballStrip.applyForce(boundary);
  //   fireballStrip.getLed(location+1).setLedColor(pitchToColor(fftLogBucket));
  // }

  //@TODO create update method to update pixel pos
  //fireballStrip.update();
  //display our fireball strip
  fireballStrip.display();
}

int pitchToColor(int data){
  if (data < 10){
    r = 0;
    g = 0;
    b = 0;
  }
  else if(data >= 10 && data < 85) {
    r = 0;
    g = data;
    b = 255 - data; 
  } 
  else if(data >= 85 && data < 170) {
   r = 255 - data; 
   g = 0;
   b = data;

  } 
  else {
   r = data; 
   g = 255 - data; 
   b = 0;
  }
  ledColor = color(r,g,b); 
  return ledColor;
}

int ampToColor(float data){
  println(data);
  int dataMapped = int(map(data, -1, 1, 0, 255));
  
  if (dataMapped < 140){
    r = 0;
    g = 0;
    b = 0;
  }
  else if(dataMapped >= 140 && dataMapped < 175) {
    r = 0;
    g = dataMapped;
    b = 0; 
  } 
  else if(dataMapped >= 175 && dataMapped < 200) {
   r = dataMapped; 
   g = dataMapped;
   b = 0;

  } 
  else {
   r = dataMapped; 
   g = 0; 
   b = 0;
  }
  int ampColor = color(r,g,b); 
  return ampColor;
}
