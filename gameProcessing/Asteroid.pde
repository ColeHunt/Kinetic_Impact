
public class Asteroid {
  
  PVector pos;
  float r;
  PVector vel;
  int total;
  int[] offset;
  
  Asteroid(PVector pos, float r) {
   this.pos = pos.copy();
   this.r = r;
    vel = PVector.random2D();
    total = floor(random(5,15));
    offset = new int[total];
    for (int i = 0; i < total; i++){ 
      offset[i] = floor(random(-this.r*0.5,this.r*0.5));
    }
  }
  
  Asteroid() {
    this.pos = new PVector(random(width),random(height));
    this.r = random(15,50);

    vel = PVector.random2D();
    total = floor(random(5,15));
    offset = new int[total];
    for (int i = 0; i < total; i++){ 
      offset[i] = floor(random(-this.r*0.5,this.r*0.5));
    }
  }
  
  public void update(){
    this.pos.add(this.vel);
  }
  
  public void edges()  { //allows for wrapping around
    if(pos.x > width + r){
      pos.x = -r;
    }else if(pos.x < -r){
      pos.x = width + r;
    }
    
    if(pos.y > height + r){
      pos.y = -r;
    }else if(pos.y < -r){
      pos.y = height + r;
    }
  }
  
  public ArrayList<Asteroid> breakup(){//TODO
    ArrayList<Asteroid> newAsteroids = new ArrayList<Asteroid>();
    
    newAsteroids.add(new Asteroid(pos, r/2));
    newAsteroids.add(new Asteroid(pos, r/2));
    
    return newAsteroids;
    
  }
  
  public void render(){
    push();
    stroke(255);
    noFill();
    translate(this.pos.x, this.pos.y);
    //ellipse(0.0,0.0,this.r*2,0.0);
    
    
    beginShape();
    for(int i = 0; i < this.total; i++){
      float angle = map(i, 0, this.total, 0, TWO_PI);
      float r2 = this.r + this.offset[i];
      float x = r2 * cos(angle);
      float y = r2 * sin(angle);
      vertex(x,y);
    }
    endShape(CLOSE);
    
    pop();
  }

}
