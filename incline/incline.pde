import controlP5.*;
import java.util.*;

ControlP5 cp5;

Slider blah;
Textlabel time;
 //<>//
int mu_s; // frictional coefficients /100
int mu_k;
int force;
int mass;
int theta;

int myColor = color(0,0,0);

void setup() {
  size(800,400);
  noStroke();
  cp5 = new ControlP5(this);
  
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
    
  cp5.addButton("play")
    .setValue(0)
    .setPosition(20,120)
    .setSize(200,19);
}

void draw() {
  background(120);
}

void slider(float nice) {
}
