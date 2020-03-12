import gab.opencv.*;
import org.openkinect.processing.*;

Kinect2 kinect;
OpenCV opencv;

int minDepth = 0;
int maxDepth = 800;
//int topBorder = 50;
//int bottomBoarder = 374;
//int leftBorder =50;
//int rightBorder = 462;

ArrayList<Contour> contours;

void setup() {
  //Size of window for video output. Depth resolution value: 512, 424
  size(512, 424);
  
  //New Kinect Object
  kinect = new Kinect2(this);
  
  //Loads the Depth Image
  kinect.initDepth();
  
  //Loads Depth/RGB Video Image
  kinect.initRegistered();
  
  //Initializes the Device. Library says it starts all sensors 
  //but doesnt work with out this
  kinect.initDevice();
}

void draw() {
  background(0);

  //Config Depth limits
  //float minDepth = map(mouseX, 0, width, 0, 4500);
  //float maxDepth = map(mouseY, 0, height, 0, 4500);
  
  //Set Image to Depth Image
  PImage img = kinect.getDepthImage();
  
  //Set Image to Depth and RGB
  //PImage img = kinect.getRegisteredImage();
  
  //function draws an image to the display window
  image(img, 0, 0);
  
  //Total Pixels in Depth range
  int pixelTotalX = 0;
  
  //Addition of all y values in depth range
  int pixelTotalY = 0;
  
  //Addition of all x values in depth range
  int pixelTotal = 0;

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
      
      //all Pixels in depth range and bewteen the boader
      //if(x > leftBorder && x < rightBorder && y > topBorder && y < bottomBoarder
      //&& rawDepth > minDepth && rawDepth < maxDepth) {
      
      //all pixels in depth range
      if(rawDepth > minDepth && rawDepth < maxDepth) {
          pixelTotalX += x;
          pixelTotalY += y;
          pixelTotal += 1;
          
          //Set all pixel in image at index to color
          img.pixels[index] = color(255,255,255);
      }
      else {
        img.pixels[index] = color(0); // corlor(0) = black
      }
    }
  }
  img.updatePixels(); // Updates pixels in image after 
  //looping through and changing them
  
  // New OpenCV Object given the img
  opencv = new OpenCV(this, img);
  
  //Finds all contrours and puts them in a Contour object array list
  contours = opencv.findContours();
  
  //prints to the console all contours found
  println("found " + contours.size() + " contours");
  
  //Updates
  image(img, 0, 0); //Updates the screen output
  
  //Sets the width of the stroke used for lines, 
  //points, and the border around shapes. 
  //All widths are set in units of pixels.
  strokeWeight(3);
  if(contours.size() > 0) {
    float maxArea = 0.0;
    Contour maxAreaContour = null;
    //maxAreaContour = contours.get(0);
    for (Contour contour : contours) {
      if (contour.area() > maxArea) {
         maxAreaContour = contour;
         maxAreaContour.draw();
         maxArea = contour.area();
      }
      
    }
    
    maxAreaContour.draw();
    stroke(255,0,0);
    beginShape();
         for (PVector point : maxAreaContour.getPolygonApproximation().getPoints()) {
           vertex(point.x, point.y);
         }
    endShape();
  }
  //for (Contour contour : contours) {
    
  //  //Sets the color used to draw lines and borders around shapes.
  //  stroke(255, 0, 0);
  //  //Draws the contours to the image
  //  contour.draw();
    
  //  stroke(255, 0, 0);
  //  beginShape();
  //  PVector p1;
    
    
  //  ////Vector stores a x, y, and sometimes z value
  //  //Get a new Contour that results from calculating the 
  //  //polygon approximation of the current Contour. Loopes
  //  //through and sets a vertex for each point on the approcinated polygon
  //  //and makes a PShape
  //  for (PVector point : contour.getPolygonApproximation().getPoints()) {
  //    vertex(point.x, point.y);
  //  }
  //  endShape();
  //  PVector point;
  //  double radius;
  //  minEnclosingCircle(contour);
  //  //rect(contour.getBoundingBox().x, contour.getBoundingBox().y, 
  //  //  contour.getBoundingBox().width, contour.getBoundingBox().height);
  //}
  //Draw a circle at the average of all pixels in range if there is at lease a 1000 pixels
  //if (pixelTotal > 1000) {
  //  ellipse(pixelTotalX / pixelTotal, pixelTotalY / pixelTotal, 40, 40);
    
  //}
}
