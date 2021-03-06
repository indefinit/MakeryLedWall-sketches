public class Strip
{
  public int size;
  public int ledDistance;
  private float positionX, positionY;
  private float height;
  private float width;
  public Led[] leds;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  
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

    float startX = 0.0;
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

  public void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  public void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    
    // Simple friction
    velocity.mult(0.95);
    
  }

}
