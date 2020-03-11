var ship;
var turnSpeed;

function setup() {
  createCanvas(800, 800);
  
  turnSpeed = 0.1;
  ship = new Ship();

}

function draw() {
  background(0);
  
  ship.update();

}

function laser(sPos, sVel, angle){ //staring position, velocity, and angle

}

function asteroid (){

}
