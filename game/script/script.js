var ship;
var turnSpeed;
var asteroids = [];
var width = 600;
var height = 600;


function setup() {
  createCanvas(600, 600);
  
  turnSpeed = 0.1;
  
  ship = new Ship();
  
  for (var i = 0; i < 5; i++){
    asteroids.push(new Asteroid());
  }
  
}

function draw() {
  background(0);
  
  ship.update();
  
  for(var j = 0; j < asteroids.length; j++){
    asteroids[j].render();
    asteroids[j].update();//moves and update positions
    asteroids[j].edges();
  } 
}

function Laser(sPos, sVel, angle){ //staring position, velocity, and angle

  this.pos = createVector();
  this.vel = createVector();
  
  
  this.update = function() {
    this.pos.add(this.vel);
    
    
    
  }
  
  this.render = function(){
    stroke(255);
    strokeWeight(4);
    point(this.x, this.y);
    
  }
  
  
}
