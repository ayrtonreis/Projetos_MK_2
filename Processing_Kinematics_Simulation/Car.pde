class Car{
  color c = color(99, 146, 221);;
  float size_x = 60;
  float size_y = 100;
  float size_helice = 24;
  float pos_x;
  float pos_y;
  float v_x;
  float v_y;
  float deg_car;
  float deg_wheel;
  float arg_wheel;
  float deg_helice;
  float deg_target;
  float t_target;
  float ball_r = 16;
  Boolean got_target = false;
  ArrayList<PVector> path;
  
  Car(){
    pos_x = width/2;
    pos_y = height - 100;
    v_x = 0;
    v_y = -4;
    
    deg_car = 0;
    deg_wheel = 0;
    arg_wheel = random(50,230);
    deg_helice = 0;
    deg_target = 0;
    t_target = 0;
    
    path = new ArrayList<PVector>();
    path.add(new PVector(pos_x,pos_y));
    
  }
  
  void drive(float final_y){
    
    if(!got_target){
    
    if(abs(pos_y-final_y) > 2){
      v_y = -abs(pos_y-final_y)/100 - 2.4;
      
      pos_x += v_x + 2*sin(radians(deg_wheel))*abs(pos_y-final_y)/100;
      pos_y += v_y + 2*cos(radians(deg_wheel));
      
      path.add(new PVector(pos_x,pos_y));
    }
    else {
      got_target = true;
    }
    
    
      deg_wheel = 10*sin(arg_wheel);
   
      arg_wheel = (arg_wheel+0.02);
      if(arg_wheel >= 360)
        arg_wheel = 0;
        
      if(abs(deg_car - (deg_wheel)) > 0.2){
        if(deg_car > deg_wheel){
          deg_car -= 0.15;
        }
        else{
           deg_car += 0.14;
        }
      }
    }
    else{
      //pos_x += 2*sin(radians(deg_target));
      pos_y += 0.6*cos(radians(deg_target))*exp(-t_target);
      
      deg_target += 20;
      
      if(t_target < 10)
        t_target+=0.008;
      
      if(deg_target >= 360)
        arg_wheel = 0;
    }
    
    deg_helice = (deg_helice+27)%360;
    
    textSize(16);
    fill(40);
    text("origin", path.get(0).x-20, path.get(0).y+20);
    stroke(40);
    strokeWeight(2);
    for (int i = 0; i < path.size(); i+=4) {
      point(path.get(i).x, path.get(i).y);
    }
      
      strokeWeight(1);
  }
  
  void display(){
    pushMatrix();
      translate(pos_x,pos_y);
      
      textSize(16);
      fill(0,0,200);
      text("θ = "+String.format("%.0f", deg_car)+"°",80, 0);
      if(got_target)
        fill(255,0,0);
      text("h = "+String.format("%.2f", (-pos_y+height - 100)*0.003)+" m",80, 20);
      
      rectMode(CENTER);
      noStroke();
      
      pushMatrix();
        translate(0,0);
        rotate(radians(deg_wheel));
        fill(100);
        rect(0,0,1.6*size_x,4);
        
        fill(0);
        rect(0.8*size_x ,0,16,32);
        rect(-0.8*size_x ,0,16,32);
        
      popMatrix();
      
      pushMatrix();
        rotate(radians(deg_car));
        translate(0,size_y/3);
        fill(c);
        rect(0,0,size_x,size_y);
        
        fill(255,0,0);
        ellipse(-size_x/4,0,ball_r,ball_r);
        fill(0,255,0);
        ellipse(size_x/4,0,ball_r,ball_r);
        
        fill(200);
        
        for(int i=-1; i<=1 ; i +=2){
          pushMatrix();
            translate(0,i*size_y/3);
            rotate(radians(deg_helice));
            beginShape();
            vertex(-size_helice,2);
            vertex(size_helice,-2);
            vertex(size_helice,2);
            vertex(-size_helice,-2);
            endShape();
          popMatrix();
        }
      popMatrix();
    
    popMatrix();
  }
  
}