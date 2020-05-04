import gab.opencv.*;
import org.openkinect.processing.*;

//********* KINECT *********
Kinect2 kinect;
Vision vision;
float angle;
OpenCV opencv;

//********* GAME *********
Ship ship;
float turnSpeed;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
int width = 600;
int height = 600;
int timer;
boolean autoFire = true;


void setup() {
  //Size of window for video output. Depth resolution value: 512, 424
  size(600, 600);
  
  //New Kinect Object
  kinect = new Kinect2(this);
  vision = new Vision(kinect);
  //angle = 0.0;
  
  //Loads the Depth Image
  kinect.initDepth();
  
  //Initializes the Device. Library says it starts all sensors 
  //but doesnt work with out this
  kinect.initDevice();

  //********* GAME *********
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
  // Uses the kinects depth array to update vision.img 
  vision.findDepth();
  // Used to find contours in vision.img
  opencv = new OpenCV(this, vision.img);
  // Finds an ArrayList of all contours in vision.img and finds the maxAreaContour
  // and maxAreaPolyApprox contour
  vision.findContours(opencv);
  // Finds center, DirectionPoint, and gameCenter point
  vision.findPoints();
  // Finds the angle between the center point and direction point
  angle = vision.findAngle(); //<>//
    
    //********* GAME *********
  
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
  ship.update(vision.gameCenter, angle);
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
    asteroids = new ArrayList<Asteroid>();
    //setup();
    timer = 0;
    autoFire = false;
    turnSpeed = 0.1;
    ship = new Ship();
    for (int i = 0; i < 5; i++){
      asteroids.add(new Asteroid());
    }
    
  }else if(key == 'a'){
    if(autoFire){
      autoFire = false;
    }else{
      autoFire = true;
    }
  }
  
}
    
