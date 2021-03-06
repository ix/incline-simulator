import controlP5.*;
import java.util.*;

ControlP5 cp5;

Textlabel time_elapsed;
Textlabel f_n;
Textlabel vel;
Textlabel accel;
Textlabel stfric;
 //<>//
float mu_s;
float mu_k;
int force;
float mass;
int theta;
boolean updown;
boolean running;

int ms_since_begin;
int ms_since_button;

float obj_pos = 0;
float curr_acc = 0;
float hypotenuse = 100;

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
    .setRange(0,50);
  cp5.addSlider("mass")
    .setPosition(20,80)
    .setRange(0,5);
  cp5.addSlider("theta")
    .setPosition(20,100)
    .setRange(0,89);
    
  // buttons
  cp5.addToggle("running")
    .setPosition(20,160)
    .setSize(50,20)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
  cp5.addToggle("updown")
    .setPosition(20,120)
    .setSize(50,20)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
    
  // text
  time_elapsed = cp5.addTextlabel("time")
                    .setText("Time elapsed:")
                    .setPosition(20,280);
  f_n = cp5.addTextlabel("fn")
           .setText("Normal force:")
           .setPosition(20,300);
  stfric = cp5.addTextlabel("static")
              .setText("Static friction:")
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
  
  ms_since_begin = millis();

  dynamic_triangle(200, 50, 550, 300, radians(theta));
  dynamic_mass(radians(theta), int(obj_pos));
  stfric.setText("Static friction: " + mu_s*normal_force(mass, radians(theta)) + "N");
  curr_acc = acceleration(friction(mu_s, normal_force(mass, radians(theta))),
                          friction(mu_k, normal_force(mass, radians(theta))),
                          mass, radians(theta), force);
                       
  if (running) {    
    float ctime = (ms_since_begin - ms_since_button) * 0.001;
    
    if (updown) {
      obj_pos = hypotenuse - position(ctime, curr_acc);
      println(obj_pos);
      if (obj_pos < 0) {
        running = false;
      }
    } else {
      obj_pos = position(ctime, curr_acc);
      if (obj_pos > hypotenuse) {
        running = false;
      }
    }
  }
}

void running(boolean flag) {
  running = flag;
  if (flag) {
    ms_since_button = millis();
  } else {
    if (updown) {
      obj_pos = hypotenuse;
    } else {
      obj_pos = 0;
    }
  }
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

void dynamic_mass(float theta, int pos) {
  pushMatrix(); // initialize the new coordinate system
  translate(200,50);
  if (theta<atan(300.0/550)) {
     translate(0,300-550*tan(theta)); 
  }
  rotate(theta);
  rect(pos,-40,40,40);
  popMatrix();
}

float normal_force(float m, float theta) {
  // mgcos(theta)
  // m is in grams, so /1000
  f_n.setText("Normal force: " + m*9.8*cos(theta) + "N");
  return m*9.8*cos(theta);
}

float friction(float mu, float f_n) {
  // f_f=mu_f*f_n
  return mu*f_n;
}

float acceleration(float st, float kn, float m, float theta, int app) {
  float f_app;
  float f_static;
  float f_kinetic;
  if (updown) {
    f_app = app;
    f_static = st + m*9.8*sin(theta);
    f_kinetic = kn + m*9.8*sin(theta);
  } else {
    f_app = app + m*9.8*sin(theta);
    f_static = st;
    f_kinetic = kn;
  }
  if (f_app < f_static) { 
    accel.setText("Acceleration: 0m/s^2");
    return 0; // we aren't moving if we aren't able to overcome static friction
  } else {
    accel.setText("Acceleration: " + ((f_app-f_kinetic)/m) + "m/s^2");
    return ((f_app-f_kinetic)/m); // a=F/m
  }
}

float position(float a, float t) {
  // x=v0t+1/2at^2, assumed that we're starting from rest, so v0=0
  return 0.5*a*pow(t, 2);
}

float velocity(float a, float t) {
  // v=v0+at, assumed we're starting from rest, so v0=0
  return a*t;
}
