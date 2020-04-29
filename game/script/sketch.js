var ship;
var turnSpeed;
var asteroids = [];
var lasers = [];
var width = 600;
var height = 600;
var timer;

var autoFire = false;

function setup() {
  createCanvas(600, 600);
  timer = 0;
  
  
  autoFire = false;
  turnSpeed = 0.1;
  
  ship = new Ship();
  
  for (var i = 0; i < 5; i++){
    asteroids.push(new Asteroid());
  }
  
}

function draw() {
  background(0);
  
  timer++;
  if(autoFire && timer % 10 == 0){
    lasers.push(new Laser(ship.pos, ship.heading));
  }
  
  
  for(var j = 0; j < asteroids.length; j++){ //may move into singular function
    if(ship.hits(asteroids[j])){
       endGame();
       break;
       //clearCanvas();
       //throw new "Game Over";
    }
    
    asteroids[j].render();
    asteroids[j].update();//moves and update positions
    asteroids[j].edges();
  } 
  
  for(var i = lasers.length-1; i >= 0; i--){
    lasers[i].render();
    lasers[i].update(); 
    
    if(lasers[i].offscreen()){
      lasers.splice(i,1);
    }else{
    
      for(var j = asteroids.length - 1; j >= 0; j--){//collison detection
        
        if (lasers[i].hits(asteroids[j])){//asteroids and laser
          if(asteroids[j].r > 15){
            var newAsteroids = asteroids[j].breakup();
            asteroids = asteroids.concat(newAsteroids);
          }
          asteroids.splice(j,1);
          lasers.splice(i,1);
          break;
        }
      }
    }
  } 
  ship.update();
}

function endGame(){
  console.log("Game Over, Press r to try agian!");
  autoFire = false;
  asteroids = [];
  lasers = [];
}

function keyPressed() {
  if(key == ' '){
    lasers.push(new Laser(ship.pos, ship.heading)); //creates a new laser at ships current position
  }else if(key == 'r'){
    setup();
  }else if(key == 'a'){
    if(autoFire){
      autoFire = false;
    }else{
      autoFire = true;
    }
  }
}
