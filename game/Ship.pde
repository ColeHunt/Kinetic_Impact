public class Ship {
  PVector pos;
  int r;
  int heading;
  PVector vel;
  public Ship(){
    
    pos = new PVector(width/2, height/2);
    r = 10;
    heading = 0;
    vel = new PVector(1,0);
  }
    public void update() {
      this.edges(); //check board edges and adjusts
      this.render(); //render piece
      this.turn(); //check to see if should turn
      this.move(); //checks to see if should move
      this.pos.add(this.vel); //moves with velocity and "decay"
      this.vel.mult(0.95); //scales decay
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
    
    public void boost()  {
      PVector force = PVector.fromAngle(heading); //TODO:
      vel.add(force.mult(0.3));
    }
    
    public void move()  {
  
      if(UP_ARROW){ 
        boost();    
      }  
    }
  
    public void turn(){
      if(LEFT_ARROW){
        heading -= turnSpeed;
      }else if(RIGHT_ARROW){
        heading += turnSpeed;
      }
    }
  }
