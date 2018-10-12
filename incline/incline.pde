import controlP5.*;
import java.util.*;

ControlP5 cp5;

Textlabel time_elapsed;
Textlabel f_n;
Textlabel vel;
Textlabel accel;
 //<>//
float mu_s;
float mu_k;
int force;
float mass;
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
    .setRange(0,1.5);
  cp5.addSlider("mu_k")
    .setPosition(20,40)
    .setRange(0,1.5);
  cp5.addSlider("force")
    .setPosition(20,60)
    .setRange(0,150);
  cp5.addSlider("mass")
    .setPosition(20,80)
    .setRange(0,1500);
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
    
  // text
  time_elapsed = cp5.addTextlabel("time")
                    .setText("Time elapsed:")
                    .setPosition(20,300);
  f_n = cp5.addTextlabel("fn")
           .setText("Normal force:")
           .setPosition(20,320);
  vel = cp5.addTextlabel("velocity") 
           .setText("Velocity:")
           .setPosition(20,340);
  accel = cp5.addTextlabel("acceleration")
             .setText("Acceleration:")
             .setPosition(20,360);
}

void draw() {
  background(120);
  stroke(0);
  
  //triangle(200,50,200,350,750,350);
  dynamic_triangle(200, 50, 550, 300, radians(theta));
  println(friction(mu_s, normal_force(mass, radians(theta))));
}

void dynamic_triangle(int xoff, int yoff, int x, int y, float theta) {
  if (atan2(y,x) == theta) { // maximum bound
    triangle(xoff, yoff, xoff, yoff+y, xoff+x, yoff+y);
  } else if (atan2(y,x) > theta) { // scale y
    triangle(xoff, yoff+y, xoff+x, yoff+y, xoff, yoff+y-x*tan(theta));
  } else if (atan2(y,x) < theta) { // scale x
    triangle(xoff, yoff+y, xoff+(y/tan(theta)), yoff+y, xoff, yoff);
  }
}

float normal_force(float m, float theta) {
  // mgcos(theta)
  // m is in grams, so /1000
  return (m/1000)*9.8*cos(theta);
}

float friction(float mu, float f_n) {
  // f_f=mu_f*f_n
  return mu*f_n;
}
