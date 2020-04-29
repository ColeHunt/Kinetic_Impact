
function Ship(){
  
  this.pos = createVector(width/2, height/2);
  this.r = 10;
  this.heading = 0;
  this.vel = createVector(1,0);

  this.update = function() {
    this.edges(); //check board edges and adjusts
    this.render(); //render piece
    this.turn(); //check to see if should turn
    this.move(); //checks to see if should move
    this.pos.add(this.vel); //moves with velocity and "decay"
    this.vel.mult(0.95); //scales decay
  }
  
  this.hits = function(asteroid){
    var d = dist(this.pos.x, this.pos.y, asteroid.pos.x, asteroid.pos.y);
    if(d < asteroid.r){
      return true;
    } else{
      return false;
    }
  }
  
  this.edges = function()  { //allows for wrapping around
    if(this.pos.x > width + this.r){
      this.pos.x = -this.r;
    }else if(this.pos.x < -this.r){
      this.pos.x = width + this.r;
    }
    
    if(this.pos.y > height + this.r){
      this.pos.y = -this.r;
    }else if(this.pos.y < -this.r){
      this.pos.y = height + this.r;
    }
  }
  
  this.render = function() {
    push();
    translate(this.pos.x, this.pos.y);    
    rotate(this.heading + PI/2);
    fill(0);
    stroke(255);
    triangle(-this.r, this.r, this.r, this.r, 0, -this.r); 
    pop();
  }
  
  this.boost = function()  {
    var force = p5.Vector.fromAngle(this.heading);
    this.vel.add(force.mult(0.3));
  }
  
  this.move = function()  {

    if(keyIsDown(UP_ARROW)){ 
      
      this.boost()
            
    }
        
  }

  this.turn = function(){
    
    if(keyIsDown(LEFT_ARROW)){
      this.heading -= turnSpeed;
    }else if(keyIsDown(RIGHT_ARROW)){
      this.heading += turnSpeed;
    }
    
    
    
  }
  
}
