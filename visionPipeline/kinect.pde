import gab.opencv.*;
import org.openkinect.processing.*;

Kinect2 kinect;
OpenCV opencv;

int minDepth = 0;
int maxDepth = 900;

ArrayList<Contour> contours;
Contour maxAreaContour = null;


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
          && maxAreaContour.containsPoint(x, y) ) {
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
    
    //maxAreaContour.draw();
    
    Contour maxAreaPolyApprox = maxAreaContour.getPolygonApproximation();
    maxAreaPolyApprox.draw();
    
    float maxDistance = 0;
    PVector DirectionPoint = maxAreaPolyApprox.getPoints().get(0);
    PVector center = new PVector(pixelTotalX / pixelTotal, pixelTotalY / pixelTotal);
    for (PVector point : maxAreaPolyApprox.getPoints()) {
      if(point.dist(center) > maxDistance) {
        maxDistance = point.dist(center);
        DirectionPoint = point;
      }
      
    }
    
    
    
    
    
    
    
    
    
    
  //  for(int x= 0; x < img.width; x++) {
  //  for (int y = 0; y < img.height; y++) {
  //    int index = x + y * img.width;
      

      
  //    if(maxAreaContour.containsPoint(x, y)) {
  //        pixelTotalX += x;
  //        pixelTotalY += y;
  //        pixelTotal += 1;
          
  
  //    }
  //  }
  //}
    
    
    
    
    
    
    
    
    //stroke(255,0,0);
    //beginShape();
    //     for (PVector point : maxAreaContour.getPolygonApproximation().getPoints()) {
    //       vertex(point.x, point.y);
    //     }
    //endShape();
    
    stroke(0,0,255);
    ellipse(DirectionPoint.x, DirectionPoint.y, 10, 10);
    ellipse(center.x, center.y, 10, 10);
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
  
    
}
