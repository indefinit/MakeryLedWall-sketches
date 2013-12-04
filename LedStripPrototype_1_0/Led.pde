public class Led
{
  private int r,g,b; //not used for now 
  private int ledColor = 0;
  
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
  public void setLedColor(color col) {
    ledColor = col;   
  }
}