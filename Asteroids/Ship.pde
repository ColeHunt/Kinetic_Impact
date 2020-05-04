public class Ship {
  PVector pos;
  int r;
  float heading;
  PVector vel;
  float turnSpeed = 0.1;

  
  boolean UP_ARROW = false;
  boolean LEFT_ARROW = false;
  boolean RIGHT_ARROW = false;
  
  public Ship(){
    
    pos = new PVector(width/2, height/2);
    r = 10;
    heading = 0;
    vel = new PVector(1,0);
  }
    public void update(PVector c, float angle) {
      heading = angle;
      this.edges(); //check board edges and adjusts
      this.render(); //render piece
      this.updatePos(c);
    }
    
    public boolean hits(Asteroid a){
      float d = dist(pos.x, pos.y, a.pos.x, a.pos.y);
      if(d < a.r){
        return true;
      } 
      else{
        return false;
      }
    }
    
    public void edges()  { //allows for wrapping around
      if(pos.x > width + r){
        pos.x = -this.r;
      }else if(pos.x < -r){
        pos.x = width + r;
      }
      
      if(pos.y > height + this.r){
        pos.y = -this.r;
      }else if(this.pos.y < -this.r){
        pos.y = height + this.r;
      }
    }
    
    public void render() {
      push();
      translate(pos.x, pos.y);    
      rotate(heading + PI/2);
      fill(0);
      stroke(255);
      triangle(-r, r, r, r, 0, -r); 
      pop();
    }
    
    public void updatePos(PVector c){
      this.pos.set(c.x, c.y);
      
      //this.heading == angle of triangle
    }
   
  }
