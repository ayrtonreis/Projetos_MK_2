void printVideoInfo(){
  String[] video_info = Capture.list();
  
  for(int i=0; i< video_info.length; i++)
    println("[", i, "]\t", video_info[i]); 
}

void captureEvent(Capture video){
  video.read(); 
  //img.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
  
   video.loadPixels();
   img.loadPixels();
  
  for ( int col = 0; col < cols; col++) {
    for ( int row = 0; row < rows; row++) {
      int x = col, y = row;
      int pixel_pos = x + y*cols; // pixel array location
      
      color c = video.pixels[pixel_pos];
      
      //Boolean is_close_1 = blob1.isColorClose(c, x, y);
      //Boolean is_close_2 = blob2.isColorClose(c, x, y);
      
        Boolean is_close_1 = false;
        Boolean is_close_2 = false;
        
        if(update_blobs){
          is_close_1 = blob1.isColorClose(c, x, y);
          is_close_2 = blob2.isColorClose(c, x, y);
        }
      
        if(is_close_1 || is_close_2){
          //img.pixels[pixel_pos] = color(255);
          img.pixels[pixel_pos] = c;
        }
        else
          img.pixels[pixel_pos] = c;
    }
  }
  if(update_blobs){
    blob1.updateTarget();
    blob2.updateTarget();
  }
  else{
    blob1.updateSearchArea();
    blob2.updateSearchArea();
  }
  
  img.updatePixels();
  
  
}

//Boolean isColorClose(float h, float s, float b, color c, float x, float y){
//  if(x > blob1.search_bound_x1 && x < blob1.search_bound_x2 && y > blob1.search_bound_y1 && y < blob1.search_bound_y2){
//    float c_h = hue(c);
//    float c_s = saturation(c);
//    float c_b = brightness(c);
//    float diff_h = abs(h-c_h), diff_s = abs(s-c_s), diff_b = abs(b-c_b);
    
//    //float diff = 4*abs(h-c_h) + 2*abs(s-c_s) + abs(b-c_b);
//    float diff = 2*diff_h*diff_h + 2*diff_s*diff_s + diff_b*diff_b;
//    //float dist = blob1.distFromAvgPos(x,y);
//    //float threshold = max(50, (blob1.avg_pos_x+blob1.avg_pos_y)/2);
//    //threshold = min(threshold, 100);
    
//    if(diff < 2000){
//      blob1.pushColorHSB(c_h,c_s,c_b,x,y);
//      return true;
//    }
//  }
  
//  return false;
//}

float transformDeg(float deg){
  if(deg >= -90 && deg <= 180){
    return deg + 90;
  }
  return deg + 450;
}

float transformRad(float rad){
  if(rad >= -PI/2 && rad <= PI){
    return 3/2*PI - rad;
  }
  return -PI/2 - rad;
}

int[] getVideoSizeInfo(int video_index){
  String video_info = Capture.list()[video_index];
  video_info = split(video_info,',')[1];
  video_info = split(video_info,'=')[1];
  String[] video_size_str = split(video_info, 'x');
  int[] video_size_int = {parseInt(video_size_str[0]), parseInt(video_size_str[1])};
  return video_size_int;
}