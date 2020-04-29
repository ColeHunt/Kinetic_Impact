
function Laser(sPos, angle){ //staring position, velocity, and angle

  this.pos = createVector(sPos.x, sPos.y);
  this.vel = p5.Vector.fromAngle(angle);
  this.vel.mult(7); //speed up lasers
  
  this.update = function() {
    this.pos.add(this.vel);
  }
  
  this.render = function(){
    push();
    stroke(255);
    strokeWeight(4);
    point(this.pos.x, this.pos.y);
    pop();
  }
  
  this.offscreen = function(){
    if(this.pos.x > width || this.pos.x < 0 ){
      return true;
    }else if(this.pos.y > height || this.pos.y < 0){
      return true;
    }else{
      return false;
    }
  }
  
  this.hits = function(asteroid){
    var d = dist(this.pos.x, this.pos.y, asteroid.pos.x, asteroid.pos.y);
    if(d < asteroid.r){
      //asteroid.break;
      //console.log("hit");
      return true;
    } else{
      return false;
    }
  }
  
  
}
