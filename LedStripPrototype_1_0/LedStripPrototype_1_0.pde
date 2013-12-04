/**
 * First prototype simulation of LED color strip for Makery Wall.
 * v.1.0.0
 * @author: StudioIndefinit
 * @date: 12/3/13
 */
Strip strip;
int ledN = 60; //change this to increase | decrease number of leds


void setup(){
  size(512, 512);
  background(255);

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
  strip.display();
}
