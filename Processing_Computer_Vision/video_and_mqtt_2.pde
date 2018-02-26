//DEVE SER INICIADO COM O LAPTOP NA TOMADA! NAO SE SABE O PORQUÊ

import processing.video.*;
import mqtt.*;

PImage img;
Capture video;
int cols, rows, cam_fps;   // Number of columns and rows of pixels in the camera
int d_width, d_height, margin_left;
Blob blob1, blob2;
Boolean update_blobs;
float setY = height/10;
float angle_deg = 0;
float h_error = 0, alpha_error = 0;
Boolean systemOn = false;
String lastCommand = "z";

MQTTClient client;
int startTime = 0;

void keyPressed() {
  //client.publish("inTopic", "Message from Processing.");
  //sendMessage("125632");
  systemOn = !systemOn;
}

void messageReceived(String topic, byte[] payload) {
  if(payload[0] != 'z')
    println("new message: " + topic + " - " + new String(payload));
}

void sendMessage(String s){
  if(lastCommand != s){
    client.publish("inTopic", s);
    lastCommand = s;
  }
}

void setup(){
  client = new MQTTClient(this);
  client.connect("mqtt://127.0.0.1", "processing");
  client.subscribe("#");
  
  size(1600,720);
  

  int video_index = 10; //38///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  video = new Capture(this, Capture.list()[video_index]);
  video.start();
  
  printVideoInfo();
  
  int[] video_size = getVideoSizeInfo(video_index);
  
  cols = video_size[0];
  rows = video_size[1];
  img = createImage(cols, rows, RGB); 
  cam_fps = 8;
  d_width = width - cols;
  d_height = height - rows;
  margin_left = 20;

  blob1 = new Blob(64,199,110, 0, cols, 0, rows); //green
  blob2 = new Blob(139,135,134, 0, cols, 0, rows); //blue
  update_blobs = true;
}

//void mouseClicked() {
//  loadPixels();
//  if(mouseX < cols){ //video area
//    int pixel_loc = mouseY*cols + mouseX;
//    final color c = video.pixels[pixel_loc];
    
//    float dist_1 = blob1.distSqr(mouseX, mouseY);
//    float dist_2 = blob2.distSqr(mouseX, mouseY);
    
//    if(dist_1 <= dist_2)
//      blob1.changeTargetColor(c);
//    else
//       blob2.changeTargetColor(c);
    
//    print("R:",red(c), "\tG:",green(c), "\tB:", blue(c));
//    println("\t\tH:",round(hue(c)), "\tS:",round(saturation(c)),"\tV:",round(brightness(c)));
//  }
  
//}

void mouseClicked(){
  if(mouseX > cols){

    setY = mouseY;
  
    print(mouseX+", setY: "+setY+"\n");
  }
}

void mouseDragged() 
{
  if(mouseX < cols){ //video area
    update_blobs = false;
    loadPixels();
    int pixel_loc = mouseY*cols + mouseX;
    final color c = video.pixels[pixel_loc];
    
    float dist_1 = blob1.distSqr(mouseX, mouseY);
    float dist_2 = blob2.distSqr(mouseX, mouseY);
    
    if(dist_1 <= dist_2){
      blob1.avg_pos_x = mouseX;
      blob1.avg_pos_y = mouseY;
      blob1.changeTargetColor(c);
    }
      
    else{
      blob2.avg_pos_x = mouseX;
      blob2.avg_pos_y = mouseY;
      blob2.changeTargetColor(c);
    }
  }
  else{
    setY = mouseY; 
  }
}

void mouseReleased() {
  if(mouseX < cols){ //video area
    update_blobs = true;
  }
}

void draw(){
  //background(0);
  
  fill(255);
  image(img, 0, 0);

  blob1.drawSearchBound();
  blob1.drawBound();
  blob1.drawCenter();
  
  blob2.drawSearchBound();
  blob2.drawBound();
  blob2.drawCenter();
  
  float angle_rad = atan2(blob1.avg_pos_x - blob2.avg_pos_x, blob1.avg_pos_y - blob2.avg_pos_y);
  angle_deg = transformDeg(degrees(angle_rad));
  
  angle_rad = TWO_PI - radians(angle_deg);

  line(blob1.avg_pos_x, blob1.avg_pos_y,blob2.avg_pos_x, blob2.avg_pos_y);
  
  
  pushMatrix();
    translate(cols, 0);
    rectMode(CORNER);
    fill(0);
    rect(0,0, d_width, height);
    
    pushMatrix();
    translate(margin_left, height-50);
      fill(255);
      textSize(16); 
      //text("H: "+round(blob1.avg_h)+"  S: "+round(blob1.avg_s)+"  B: "+round(blob1.avg_b), width/2, height-50);
      text("X1: "+round(blob1.avg_pos_x)+"  Y1: "+round(blob1.avg_pos_y), margin_left, 0);
      text("X2: "+round(blob2.avg_pos_x)+"  Y2: "+round(blob2.avg_pos_y), margin_left, 30);
      colorMode(HSB);
      fill(blob1.avg_h,blob1.avg_s,blob1.avg_b);
      int color_diameter = (update_blobs ? 16:32);
      ellipse(0,-6, color_diameter, color_diameter);
      fill(blob2.avg_h,blob2.avg_s,blob2.avg_b);
      ellipse(0,24, color_diameter, color_diameter);
      colorMode(RGB);
    popMatrix();
    
    fill(255);
    noStroke();
    triangle(0, setY, 50, setY-10, 50, setY+10);
    
    translate(160, 100);
    fill(255);
    textSize(40);
    text(round(angle_deg)+"°", -44, 12);
    int diameter = 160;
    stroke(255);
    noFill();

    arc(0, 0, diameter, diameter, angle_rad, TWO_PI);
    
    pushMatrix();
      rotate(angle_rad);
      translate(diameter/2,0);
      line(0,0,8,10);
      line(0,0,-8,10);
    popMatrix(); 
    
  popMatrix();
  
  stroke(abs(h_error) < 40 ? color(64,250,70) : color(255,64,64));
  strokeWeight(2);
  line(0, setY, cols-2, setY);
  stroke(0);
  strokeWeight(1);
  line(0, setY, cols-2, setY);
  
  pushMatrix();
        translate(cols+100, 256);
        fill(255);
        textSize(18);
        text("height_error: "+round(h_error), 0, 0);
        text("angle_error: "+round(alpha_error)+"°", 0, 20);
        textSize(64);
        fill(systemOn ? color(50,255,50) :color(100,0,0));
        text(systemOn ? "ON":"OFF", 0, 200);
  popMatrix();
  
  if(rows < 1280){
    noStroke();
    fill(0);
    rect(0, rows, cols, height-rows);
  }
  
  controlCar();
  
}

void controlCar(){
  if(millis() - startTime > 32){
    h_error = (blob1.avg_pos_y+blob2.avg_pos_y)/2 - setY;
    alpha_error = angle_deg < 180 ? angle_deg : 360 - angle_deg;
    
    //ALL MOTORS OFF
    if(!systemOn){
      sendMessage("z");
    }
    else if(abs(h_error) < 40){
      sendMessage("s"); 
    }
    //ANGLE DEVIATION HAS PRIORITY
    else if(angle_deg > 15 && angle_deg < 345){
      if(angle_deg < 180){
        //turn right
        sendMessage("r");
      }
      else{
        //turn left
        sendMessage("l"); 
      }
    }
    else{
        if(h_error > 0 && abs(h_error) > 40){
          sendMessage("f");
        }
        else if(h_error < 0 && abs(h_error) > 40){
          sendMessage("b");
        }
        //STAY STILL
        else
          sendMessage("s");   
    }
      startTime = millis();
      
  }
}