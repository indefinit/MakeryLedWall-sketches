public class Strip
{
  public int size;
  private float positionX, positionY;
  private float height;
  private float width;
  public Led[] leds;


  //--------------------------------------
  //  CONSTRUCTOR
  //--------------------------------------
  
  public Strip (int size, float positionX, float positionY, float width) {
    this.size = size;
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

    float startX = 0.0;
    for (int i = 0; i<leds.length; i++){
      fill(leds[i].getColor()); //fill in each led with color
      if (i == 1){
        rect(0, 0, (width/leds.length), height);
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
