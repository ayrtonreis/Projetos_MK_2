class Blob{
  private long h, s, b;
  private float first_h, first_s, first_b, first_parameter;
  private float avg_h, avg_s, avg_b;
  private int count;
  
  private float pos_x, pos_y;
  float min_x, min_y, max_x, max_y, d_x, d_y;;
  float avg_pos_x, avg_pos_y, avg_d_x, avg_d_y;
  float search_bound_x1, search_bound_x2, search_bound_y1, search_bound_y2;
    
  Blob(){
    h = s = b = count = 0;
    pos_x = pos_y = d_x = d_y = 0;
    avg_pos_x = cols/2;
    avg_pos_y = rows/2;
    min_x = min_y = -9999;
    max_x = max_y = 9999;
  }
  
  Blob(float h1, float s1, float b1, float bound_x1, float bound_x2, float bound_y1, float bound_y2){
    h = s = b = count = 0;
    pos_x = pos_y = d_x = d_y = 0;
    avg_pos_x = cols/2;
    avg_pos_y = rows/2;
    min_x = min_y = 9999;
    max_x = max_y = -9999;
     
    first_h = avg_h = h1;
    first_s = avg_s = s1; 
    first_b = avg_b = b1;
    first_parameter = (first_h + first_s + first_b)*0.1;
    search_bound_x1 = bound_x1;
    search_bound_x2 = bound_x2;
    search_bound_y1 = bound_y1;
    search_bound_y2 = bound_y2;
  }
  
  void pushColorHSB(float h1, float s1, float b1, float x, float y){
    h += h1;
    s += s1;    
    b += b1;
    pos_x += x;
    pos_y += y;
    min_x = min(x, min_x);
    min_y = min(y, min_y);
    max_x = max(x, max_x);
    max_y = max(y, max_y);
    
    count++;
    
  }
  
  Boolean isColorClose(color c, float x, float y){
    if(x > search_bound_x1 && x < search_bound_x2 && y > search_bound_y1 && y < search_bound_y2){
      float c_h = hue(c);
      float c_s = saturation(c);
      float c_b = brightness(c);
      float diff_h = abs(avg_h-c_h), diff_s = abs(avg_s-c_s), diff_b = abs(avg_b-c_b);
      
      //float diff = 4*abs(h-c_h) + 2*abs(s-c_s) + abs(b-c_b);
      float diff = 4*diff_h*diff_h + 2*diff_s*diff_s + diff_b*diff_b/4;
      //float dist = .distFromAvgPos(x,y);
      //float threshold = max(50, (.avg_pos_x+.avg_pos_y)/2);
      //threshold = min(threshold, 100);
    
      if(diff < 1000){
        pushColorHSB(c_h,c_s,c_b,x,y);
        return true;
      }
  }
  
    return false;
  }
  
  void updateTarget(){
    if(count != 0){
      //float diff = 4*abs(first_h - avg_h)*abs(first_h - avg_h) + 2*abs(first_s - avg_s)*abs(first_s - avg_s) + abs(first_b - avg_b)*abs(first_b - avg_b)/4;
      float diff = 4*abs(first_h - avg_h) + abs(first_s - avg_s) + abs(first_b - avg_b);
      if( diff < first_parameter && count > 64){
        avg_pos_x = pos_x/count;
        avg_pos_y = pos_y/count;
      }
      else{
        //avg_h = first_h;
        //avg_s = first_s;
        //avg_b = first_b;
      }
      
      h = s = b = count = 0;
      pos_x = pos_y = 0;
      
      d_x = max_x - min_x;
      d_y = max_y - min_y;
      
      updateSearchArea();
      
    }
    else { // if only a few pixels were matched
      search_bound_x1 = 0;
      search_bound_y1 = 0;
      search_bound_x2 = cols;
      search_bound_y2 = rows;
    }

  }
  
  float distFromAvgPos(float x, float y){
    float dist = 0;
    if(avg_pos_x != 0 && avg_pos_y != 0)
      dist = abs(x - avg_pos_x) + abs(y - avg_pos_y);
     
     return dist;
  }
  
  void updateSearchArea(){
      float bound_constant = 1.4;

      if(d_x*d_y > 800)
        bound_constant = 1.1;
      
      search_bound_x1 = max(0, avg_pos_x - bound_constant*d_x);
      search_bound_y1 = max(0, avg_pos_y - bound_constant*d_y);
      search_bound_x2 = min(cols, avg_pos_x + bound_constant*d_x);
      search_bound_y2 = min(rows, avg_pos_y + bound_constant*d_y);
      
      min_x = max_x;
      min_y = max_y;
      max_x = max_y = 0;
  }
  
  void changeTargetColor(color c){
    avg_h = first_h = hue(c);
    avg_s = first_s = saturation(c);
    avg_b = first_b = brightness(c);
  }
  
  void drawSearchBound(){
    fill(255, 0, 0);
    noStroke();
    ellipse(search_bound_x1,search_bound_y1, 10, 10);
    ellipse(search_bound_x1,search_bound_y2, 10, 10);
    ellipse(search_bound_x2,search_bound_y1, 10, 10);
    ellipse(search_bound_x2,search_bound_y2, 10, 10); 
  }
  
  void drawBound(){
    noFill();
    stroke(255);
    strokeWeight(2);
    rectMode(CENTER);
    rect(avg_pos_x,avg_pos_y, d_x, d_y);
  }
  
  void drawCenter(){
      ellipseMode(CENTER); 
      stroke(0);
      strokeWeight(2);
      fill(255);
      ellipse(avg_pos_x,avg_pos_y, 8, 8);
  }
  
  float distSqr(float x, float y){
    return(abs(x-avg_pos_x)*abs(x-avg_pos_x) + abs(y-avg_pos_y)*abs(y-avg_pos_y));
  }
}