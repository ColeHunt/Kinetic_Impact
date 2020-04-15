import gab.opencv.*;
import org.openkinect.processing.*;

Kinect2 kinect;
OpenCV opencv;

//Minimum and maximum depth value for the kinect to look for. (200 - 4500)
int minDepth = 0;
int maxDepth = 1000;

//List of all countours found when opencv.findContours() is called
ArrayList<Contour> contours;
// Countour with the most area
Contour maxAreaContour = null;
// A more simple polygon version of the maxAreaContour
Contour maxAreaPolyApprox;
//Center point of the object (average point in maxAreaPolyApprox)
PVector center;
// Point furthest from the center, used to find direction
PVector DirectionPoint;
float maxDistance = 0;

int count = 0;
PrintWriter output;
int start;

void setup() {
  //Size of window for video output. Depth resolution value: 512, 424
  size(512, 424);
  
  frameRate(20);
  
  //New Kinect Object
  kinect = new Kinect2(this);
  
  //Loads the Depth Image
  kinect.initDepth();
  
  //Loads Depth/RGB Video Image
  kinect.initRegistered();
  
  //Initializes the Device. Library says it starts all sensors 
  //but doesnt work with out this
  kinect.initDevice();
  
  output = createWriter("output.csv");
  output.println("512, 424");
  
}

void draw() {
  background(0);

  //Config Depth limits
  //float minDepth = map(mouseX, 0, width, 0, 4500);
  //float maxDepth = map(mouseY, 0, height, 0, 4500);
  
  //Set Image to Depth Image
  PImage img = kinect.getDepthImage();
  
  //Set Image to Depth and RGB
  
  //function draws an image to the display window
  image(img, 0, 0);
  
  //Total Pixels in Depth range
  int pixelTotalX = 0;
  
  //Addition of all y values in depth range
  int pixelTotalY = 0;
  
  //Addition of all x values in depth range
  int pixelTotal = 1;

  //For calibration
  //println(minDepth + " " + maxDepth);
  
  //A 1-D array of all depth values
  int[] depth = kinect.getRawDepth();
  
  //Loop through all pixels in image and increment the x and y values 
  for(int x= 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      
      //Scales the x and y values to a 1-D array value of the pixel
      int index = x + y * img.width;
      
      //Depth value for this pixel
      int rawDepth = depth[index];
      
      //All pixels in the maximum contour
      if(rawDepth > minDepth && rawDepth < maxDepth && contours.size() > 0 
          && maxAreaPolyApprox.containsPoint(x, y) ) {
          pixelTotalX += x;
          pixelTotalY += y;
          pixelTotal += 1;
          img.pixels[index] = color(255,255,255);
          
          //Set all pixel in image at index to color
          
      }
      //all pixels in depth range
      else if(rawDepth > minDepth && rawDepth < maxDepth) {
        img.pixels[index] = color(255,255,255);
      }
      else {
        img.pixels[index] = color(0); // corlor(0) = black
      }
    }
  }
  img.updatePixels(); // Updates pixels in image after 
  
  // New OpenCV Object given the img
  opencv = new OpenCV(this, img);
  
  //Finds all contrours and puts them in a Contour object array list
  contours = opencv.findContours();
  
  //Updates
  image(img, 0, 0); //Updates the screen output
  
  //Sets the width of the stroke used for lines, 
  //points, and the border around shapes. 
  //All widths are set in units of pixels.
  strokeWeight(3);
  
  //Run once countours are found
  if(contours.size() > 0) {
    float maxArea = 0.0;
    //maxAreaContour = contours.get(0);
    
    //Find the countour with the max area
    for (Contour contour : contours) {
      if (contour.area() > maxArea) {
         maxAreaContour = contour;
         maxArea = contour.area();
      }
    }
    
    maxAreaPolyApprox = maxAreaContour.getPolygonApproximation();
    
    //Draws maxAreaPolyApprox to screen 
    stroke(255,0,0);
    maxAreaPolyApprox.draw();
    
    
    DirectionPoint = maxAreaPolyApprox.getPoints().get(0);
    center = new PVector(pixelTotalX / pixelTotal, pixelTotalY / pixelTotal);
    maxDistance = 0;
    //Find DirectionPoint (point furthest from the center)
    for (PVector point : maxAreaContour.getPoints()) {
      if(point.dist(center) > maxDistance) {
        maxDistance = point.dist(center);
        DirectionPoint = point;
      }
    }
    println(maxDistance);
    
    //Draws the center point and the direction point to screen
    stroke(0,0,255);
    ellipse(DirectionPoint.x, DirectionPoint.y, 10, 10);
    ellipse(center.x, center.y, 10, 10);
    
    
    
    //To output data to file and output a video recording of the screen
    count++;
    saveFrame("output/line-#####.png");
    if(maxAreaPolyApprox.area() > 1000 && count < 1000) {
      output.println(center.x + ", " + center.y + ", " + 
        DirectionPoint.x + ", " + DirectionPoint.y);
    }
    else if(count >= 1000) {
      output.flush();
      output.close();
      exit();
    }
    else {
      output.println("-1, -1, -1, -1");
    }
    
  }
}
