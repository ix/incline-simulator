import controlP5.*;
import java.util.*;

ControlP5 cp5;

Textlabel time_elapsed;
 //<>//
int mu_s; // frictional coefficients /100
int mu_k;
int force;
int mass;
int theta;
boolean updown;

int myColor = color(0,0,0);

void setup() {
  size(800,400);
  noStroke();
  cp5 = new ControlP5(this);
  
  // sliders
  cp5.addSlider("mu_s")
    .setPosition(20,20)
    .setRange(0,150);
  cp5.addSlider("mu_k")
    .setPosition(20,40)
    .setRange(0,150);
  cp5.addSlider("force")
    .setPosition(20,60)
    .setRange(0,150);
  cp5.addSlider("mass")
    .setPosition(20,80)
    .setRange(0,150);
  cp5.addSlider("theta")
    .setPosition(20,100)
    .setRange(0,90);
    
  // buttons
  cp5.addButton("play")
    .setValue(0)
    .setPosition(20,160)
    .setSize(130,19);
  cp5.addToggle("updown")
    .setPosition(20,120)
    .setSize(50,20)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
    
  // time elapsed
  time_elapsed = cp5.addTextlabel("label")
                    .setText("Time elapsed:")
                    .setPosition(80,125);
}

void draw() {
  background(120);
  stroke(0);
  
  //triangle(200,50,200,350,750,350);
  dynamic_triangle(200, 50, 550, 300, radians(theta));
}

// TODO: probably holding the wrong point constant?
void dynamic_triangle(int xoff, int yoff, int x, int y, float theta) {
  if (atan(y/x) == theta) { // maximum bound
    triangle(xoff, yoff, xoff, yoff+y, xoff+x, yoff+y);
  } else if (atan(y/x) < theta) { // scale y
    triangle(xoff, yoff, xoff, yoff+x*tan(theta), xoff+x, yoff+x*tan(theta));
  }
}
