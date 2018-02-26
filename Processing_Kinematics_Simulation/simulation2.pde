Car car;
Boolean was_clicked = false;
float clicked_y = 0;
float y_converted = 0;

void setup(){
  size(800,1000);
  background(255);
  car = new Car();
  frameRate(30);
}

void draw(){
  //fill(255,125);
  //rect(0,0,width*2,height*2);  
  background(255);
  
  if(!was_clicked){
    pushMatrix();
      translate(width/2,height);
      stroke(0);
      line(0,-20,0,mouseY-height);
      line(-8,mouseY-height+8,0,mouseY-height);
      line(8,mouseY-height+8,0,mouseY-height);
    popMatrix();
    
    textSize(16);
    fill(0);
    text(String.format("%.2f", (height-100-mouseY)*0.003)+" m",width/2-20, mouseY-10);
    
  }
  else{
    stroke(0);
    line(0,clicked_y,width,clicked_y);
    
    textSize(16);
    fill(0);
    text(String.format("%.2f", y_converted)+" m",width-100, clicked_y-10);
    
    car.drive(clicked_y);
  }
  
  car.display();
  
  textSize(10);
  fill(64);
  text("Simulation by:\nAyrton\nGuilherme\nHélio\nLuiz Guilherme\nVictor",width-100, height-100);
}

void mouseClicked(){
  if(!was_clicked){
    was_clicked = true;
    clicked_y = mouseY;
    y_converted = (height-100-clicked_y)*0.003;
    ellipseMode(CENTER);
    fill(255,0,0);
    ellipse(width/2,clicked_y,10,10);
  }
}