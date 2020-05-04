
public class Vision {
  //Minimum and maximum depth value for the kinect to look for. (200 - 4500)
  private int minDepth;
  private int maxDepth;
  //List of all countours found when opencv.findContours() is called
  public ArrayList<Contour> contours;
  // Countour with the most area
  private Contour maxAreaContour;
  // A more simple polygon version of the maxAreaContour
  private Contour maxAreaPolyApprox;
  //Center point of the object (average point in maxAreaPolyApprox)
  public PVector center;
  // Point furthest from the center, used to find direction
  public PVector DirectionPoint;
  private float maxDistance;
  private int borderX;
  private int borderY;
  public PImage img;
  public PVector gameCenter;
  //Total Pixels in Depth range
  private int pixelTotalX;
  //Addition of all y values in depth range
  private int pixelTotalY;
  //Addition of all x values in depth range
  private int pixelTotal;
  private Kinect2 kinect;
  public Vision(Kinect2 kinect) {
    borderX = 100;
    borderY = 100;
    pixelTotal = 1;
    pixelTotalY = 0;
    pixelTotalX = 0;
    maxDistance = 0;
    minDepth = 0;
    maxDepth = 1500;
    this.kinect = kinect;
    maxAreaContour = null;
    img = createImage(512, 424, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(0, 0, 0); 
    }
    img.updatePixels();
    gameCenter = new PVector(0, 0);
 }
 
 public void findDepth() {
   pixelTotal = 1;
   pixelTotalY = 0;
   pixelTotalX = 0;
   //A 1-D array of all depth values
  int[] depth = kinect.getRawDepth();
  //Loop through all pixels in image and increment the x and y values 
  for(int x= borderX; x < img.width - borderX; x++) {
    for (int y = borderY; y < img.height - borderY; y++) {
      //Scales the x and y values to a 1-D array value of the pixel
      int index = x + y * img.width;
      //Depth value for this pixel
      int rawDepth = depth[index];
      //All pixels in the maximum contour
      if(rawDepth > minDepth && rawDepth < maxDepth && contours.size() > 0
          && maxAreaPolyApprox.containsPoint(x, y)) {
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
  //image(img, 0, 0);
 }
 public void findContours(OpenCV opencv) {
  contours = opencv.findContours();
  //Run once countours are found
  if(contours.size() > 0) {
    float maxArea = 0.0;
    //Find the countour with the max area
    for (Contour contour : contours) {
      if (contour.area() > maxArea) {
         maxAreaContour = contour;
         maxArea = contour.area();
      }
    }
    maxAreaPolyApprox = maxAreaContour.getPolygonApproximation();
 }
 }
 public void findPoints() {
  if (contours.size() > 0) {
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
    //println(DirectionPoint.x, " ", DirectionPoint.y);
    gameCenter.set(floor(((center.x - borderX) * 600) / (512 - (2 * borderX))), 
      floor(((center.y - borderY) * 600) / (424 - (2 * borderY))));
  }
 }
 public float findAngle() {
   float angle = 0.0;
   if (vision.contours.size() > 0) {  
    //Finds the angle from the center Point to the Direction Point
    angle = -PVector.angleBetween(new PVector(1,0), 
      new PVector(vision.DirectionPoint.x - vision.center.x, 
      vision.DirectionPoint.y - vision.center.y));
    // Angle is given in only the smallest angle so this if statement turnes the 
    // angle negative once the angle has passed pi radian
    if (vision.center.y < vision.DirectionPoint.y) {
      angle =  -angle;
    }
  }
   return angle;
 }
}
