public class Laser{
  
  PVector pos;
  PVector vel;
  Laser(PVector sPos, int angle){ //staring position, velocity, and angle
  
    pos = new PVector(sPos.x, sPos.y);
    vel = PVector.fromAngle(angle);
    vel.mult(7); //speed up lasers
  }
  
    public void update() {
      pos.add(this.vel);
    }
    
    public void render(){
      push();
      stroke(255);
      strokeWeight(4);
      point(pos.x, pos.y);
      pop();
    }
    
    public boolean offscreen(){
      if(pos.x > width || pos.x < 0 ){
        return true;
      }else if(pos.y > height || pos.y < 0){
        return true;
      }else{
        return false;
      }
    }
    
    public boolean hits(Asteroid a){
      float d = dist(this.pos.x, this.pos.y, a.pos.x, a.pos.y);
      if(d < a.r){
        //asteroid.break;
        //console.log("hit");
        return true;
      } else{
        return false;
      }
    }
}
    
