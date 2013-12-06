import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LedStripPrototype_1_0 extends PApplet {

/**
 * First prototype simulation of LED color strip for Makery Wall.
 * v.1.0.0
 * @author: StudioIndefinit
 * @date: 12/3/13
 */



Minim minim;
AudioInput in;
FFT fftLin;
FFT fftLog;
int spectrumScale = 4; // scaling value for our spectrum
float pitch;
int r,g,b;
int ledColor = color(255,255,255,100);

Strip strip;
Strip fireballStrip;

int ledN = 60; //change this to increase | decrease number of leds
int fftN = ledN*2; //double the led number

public void setup(){
  size(1024, 512);
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
  fftLin.linAverages(fftN);


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

public void draw(){
  
  float centerFrequency = 0;

  fftLin.forward( in.left );
  fftLog.forward(in.left);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < fftLog.avgSize(); i++){
    //println(i);
    
    centerFrequency    = fftLog.getAverageCenterFrequency(i);
    // how wide is this average in Hz?
    float averageWidth = fftLog.getAverageBandWidth(i);   
      
      // we calculate the lowest and highest frequencies
      // contained in this average using the center frequency
      // and bandwidth of this average.
      float lowFreq  = centerFrequency - averageWidth/2;
      float highFreq = centerFrequency + averageWidth/2;
      
      // freqToIndex converts a frequency in Hz to a spectrum band index
      // that can be passed to getBand. in this case, we simply use the 
      // index as coordinates for the rectangle we draw to represent
      // the average.
      int xl = (int)fftLog.freqToIndex(lowFreq);
      int xr = (int)fftLog.freqToIndex(highFreq);

    int fftLogBucket = PApplet.parseInt(map(fftLog.getAvg(i), 0, 10, 0, 255));
    int fftLinBucket = PApplet.parseInt(map(fftLin.getAvg(i), 0, 10, 0, 255));
    //println(fftLogBucket);
    //strip.getLed(i-60).setLedColor(pitchToColor(fftLinBucket));
    strip.getLed(i).setLedColor(pitchToColor(fftLogBucket));
  }
  //display our frequency spectrum strip
  strip.display(); 
  
  for(int i = 0; i < ledN; i++){
    fireballStrip.getLed(i).setLedColor(ampToColor(in.left.get(i)));
  }
  //display our fireball strip
  fireballStrip.display();
}

public int pitchToColor(int data){
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

public int ampToColor(float data){
  println(data);
  int dataMapped = PApplet.parseInt(map(data, -1, 1, 0, 255));
  
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
public class Led
{
  private int r,g,b; //not used for now 
  private int ledColor = color(255);
  
  //--------------------------------------
  //  CONSTRUCTOR
  //--------------------------------------
  
  public Led () {}

  //--------------------------------------
  //  METHODS
  //--------------------------------------
  public int getColor() { //in Java mode, colors are returned as integers 
   
    return ledColor;
  }

  // @TODO add more setLedColor methods to handle r,g,b and h,s,b inputs
  public void setLedColor(int col) {
    ledColor = col;   
  }
}
public class Strip
{
  public int size;
  public int ledDistance;
  private float positionX, positionY;
  private float height;
  private float width;
  public Led[] leds;


  //--------------------------------------
  //  CONSTRUCTOR
  //--------------------------------------
  
  public Strip (int size, float positionX, float positionY, float width) {
    this.size = size;
    this.ledDistance = ledDistance;
    this.positionX = positionX;
    this.positionY = positionY;
    this.height = width/size; //ensures our pixels are always square inside the strip
    this.width = width;

    this.leds = new Led[size];
    for (int i = 0; i<leds.length; i++){
      leds[i] = new Led();
    }
  }

  //--------------------------------------
  //  METHODS
  //--------------------------------------
  public void display() {
    noFill();
    stroke(0);
    pushMatrix();
    translate(positionX, positionY);
    rect(0, 0, width, height); //our led holder rectangle

    float startX = 0.0f;
    for (int i = 0; i<size; i++){
      fill(leds[i].getColor()); //fill in each led with color
      if (i == 0){
        rect(0, 0, (width/leds.length), height); //##this makes the second led light up first, and the first one second. lets fix.
      } 
      else {
        rect(startX += (width/leds.length), 0, (width/leds.length), height);
      }
    }
    popMatrix();
  }
  
  public Led[] getLeds() {
    return leds;
  }

  public Led getLed(int i) {
    return leds[i];
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "LedStripPrototype_1_0" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
