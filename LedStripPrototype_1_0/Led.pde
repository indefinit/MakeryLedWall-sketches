public class Led
{
  private int r,g,b; //not used for now 
  private color ledColor = color(255,255,255,100);
  private float pitch;
  
  //--------------------------------------
  //  CONSTRUCTOR
  //--------------------------------------
  
  public Led () {}

  //--------------------------------------
  //  METHODS
  //--------------------------------------
  public color getColor() { //in Java mode, colors are returned as integers 
    pitch = map(mouseY, 0, height, 0, 255);
    int pitchScale = int(256-pitch);
  if(pitchScale < 85) {
    r = pitchScale * 3; 
    g = 255 - pitchScale * 3; 
    b = 0;
   ledColor = color(r,g,b);
  } else if(pitchScale < 170) {
   pitchScale -= 85;
   r = 255 - pitchScale * 3; 
   g = 0;
   b = pitchScale * 3;
   ledColor = color(r,g,b);
  } else {
   pitchScale -= 170;
   r = 0;
   g = pitchScale * 3;
   b = 255 - pitchScale * 3;
   ledColor = color(r,g,b);
  }
    return ledColor;
  }

  // @TODO add more setLedColor methods to handle r,g,b and h,s,b inputs
  public void setLedColor(color col) {
    ledColor = col;   
  }
}
