Ship ship;
float turnSpeed;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
int width = 600;
int height = 600;
int timer;
boolean UP_ARROW = false;
boolean LEFT_ARROW = false;
boolean RIGHT_ARROW = false;

boolean autoFire = false;

void setup() {
  size(600, 600);
  timer = 0;
  
  
  autoFire = false;
  turnSpeed = 0.1;
  
  ship = new Ship();
  
  for (int i = 0; i < 5; i++){
    asteroids.add(new Asteroid());
  }
  
}

void draw() {
  background(0);
  
  timer++;
  if(autoFire && timer % 10 == 0){
    lasers.add(new Laser(ship.pos, ship.heading));
  }
  
  
  for(int j = 0; j < asteroids.size(); j++){ //may move into singular function
    if(ship.hits(asteroids.get(j))){
       endGame();
       break;
       //clearCanvas();
       //throw new "Game Over";
    }
    
    asteroids.get(j).render();
    asteroids.get(j).update();//moves and update positions
    asteroids.get(j).edges();
  } 
  
  for(int i = lasers.size()-1; i >= 0; i--){
    lasers.get(i).render();
    lasers.get(i).update(); 
    
    if(lasers.get(i).offscreen()){
      lasers.remove(i);
    }else{
    
      for(int j = asteroids.size() - 1; j >= 0; j--){//collison detection
        
        if (lasers.get(i).hits(asteroids.get(j))){//asteroids and laser
          if(asteroids.get(j).r > 15){
            ArrayList<Asteroid> newAsteroids = asteroids.get(j).breakup();
            asteroids.addAll(newAsteroids);
          }
          asteroids.remove(j);
          lasers.remove(i);
          break;
        }
      }
    }
  } 
  ship.update();
}

public void endGame(){
  print("Game Over, Press r to try agian!");
  autoFire = false;
  asteroids = new ArrayList<Asteroid>();
  lasers = new ArrayList<Laser>();
}

public void keyPressed() {
  if(key == ' '){
    lasers.add(new Laser(ship.pos, ship.heading)); //creates a new laser at ships current position
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
