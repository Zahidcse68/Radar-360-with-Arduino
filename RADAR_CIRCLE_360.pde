import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort;
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont;
boolean objectDetected = false; // Flag to track object detection

void setup() {
  size(1300, 700);
  smooth();
  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('.');
}

void draw() {
  fill(98, 245, 31);
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31);
  drawRadar();
  drawLine(); // Call drawLine function to handle color change
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length() - 1);

  index1 = data.indexOf(",");
  angle = data.substring(0, index1);
  distance = data.substring(index1 + 1, data.length());

  iAngle = int(angle);
  iDistance = int(distance);

  // Update objectDetected flag based on distance
  if (iDistance <= 80) {
    objectDetected = true;
  } else {
    objectDetected = false;
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height / 2); // Center the radar circle
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  for (int i = 0; i < 360; i += 30) {
    ellipse(0, 0, 2 * height * 0.4, 2 * height * 0.4); // Adjust the size of the circle
    float x = (height * 0.4) * cos(radians(i));
    float y = (height * 0.4) * sin(radians(i));
    line(0, 0, x, y);
    text(str(i), x, y);
  }

  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height / 2); // Center the radar circle
  strokeWeight(9);

  if (objectDetected) {
    stroke(255, 10, 10); // Red color for detected objects
  } else {
    stroke(98, 245, 31); // Green color for no detection
  }

  pixsDistance = map(iDistance, 0, 80, 0, height * 0.4);

  if (iDistance <= 80) {
    float x = pixsDistance * cos(radians(iAngle));
    float y = pixsDistance * sin(radians(iAngle));
    point(x, y);
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  
  if (objectDetected) {
    stroke(255, 10, 10); // Red color for detected objects
  } else {
    stroke(30, 250, 60); // Change color to green for rotating lines
  }

  translate(width / 2, height / 2); // Center the radar circle
  float x = (height * 0.4) * cos(radians(iAngle));
  float y = (height * 0.4) * sin(radians(iAngle));
  line(0, 0, x, y);
  popMatrix();
}

void drawText() {
  pushMatrix();
  if (iDistance > 80) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }
  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);

  text("ZAHID BASHIR", width - width * 0.875, height - height * 0.0277);
  text("Angle: " + iAngle + " ", width - width * 0.88, height - height * 0.0877);
  text("Distance: " + iDistance + " cm", width - width * 0.265, height - height * 0.0877);
  textSize(25);
  fill(98, 245, 60);

  popMatrix();
}
