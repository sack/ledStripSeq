
//array of leds
 ArrayList<Led> leds;
String[] frames;
boolean play = false;

void setup() {
  size(1280, 720);  
  leds = new ArrayList<Led>();
  frameRate(10);
}
void draw() {
  //grey background
  background(200);
  //draw a grid every 32 pixels
  for (int i = 0; i < width; i+=32) {
    for (int j = 0; j < height; j+=32) {
      noFill();
      stroke(0, 32);
      rect(i, j, 32, 32);
    }
  }
  
  //draw all leds
  for (int i = 0; i < leds.size(); i++) {
    leds.get(i).draw();
    if (i>0) {
      //draw a line between the current led and the previous one
      line(leds.get(i).x+16, leds.get(i).y+16, leds.get(i-1).x+16, leds.get(i-1).y+16);
    }
  }
  //draw a line between the current led and the mouse 
  if (leds.size()>0) {
    //line(leds.get(leds.size()-1).x+16, leds.get(leds.size()-1).y+16, mouseX, mouseY);
    line(leds.get(leds.size()-1).x, leds.get(leds.size()-1).y, mouseX, mouseY);
    fill(0, 32);
    rect(mouseX, mouseY,32,32);
  }
  if (play) {
    //display the leds in the current frame
    for (int i = 0; i < leds.size(); i++) {
      String[] parts = split(frames[frameCount%frames.length], ',');
      int r = PApplet.parseInt(parts[i*3]);
      int g = PApplet.parseInt(parts[i*3+1]);
      int b = PApplet.parseInt(parts[i*3+2]);
      leds.get(i).c = color(r,g,b);
    }
  }




}
void mouseClicked() {
  //create a new led
   leds.add(new Led(mouseX,mouseY,leds.size()));

}
void keyPressed() {
  if (key == 'u') {
     //delete the last led
    if (leds.size()>0) {
      leds.remove(leds.size()-1);
    }
  }
  if (key == 's') 
  {
    //save the led positions to a file
    saveLeds();
  }
   if (key == 'l'){
    //load the led positions from a file
    loadLeds();
   } 
   if (key == 'c'){
    //load the led animations from a file
    loadAnimations();
   }

 if (key == 'x'){
    //load the led animations from a file
    createAnimationFile();
 }
 if (key == ' '){
    //load the led animations from a file
    play = !play;
 }

}

void loadAnimations() {
  //load the leds animations from a file
  frames = loadStrings("animations.txt");
  for (int i = 0; i < frames.length; i++) {
    for (int j = 0; j < leds.size(); j++) {
      String[] parts = split(frames[i], ',');
      int r = PApplet.parseInt(parts[j*3]);
      int g = PApplet.parseInt(parts[j*3+1]);
      int b = PApplet.parseInt(parts[j*3+2]);
      leds.get(j).c = color(r,g,b);

    }
  }
}


void loadLeds() {
  //load the led positions from a file
  String[] lines = loadStrings("leds.txt");
  leds.clear();
  for (int i = 0; i < lines.length; i++) {
    String[] parts = split(lines[i], ',');
    int x = PApplet.parseInt(parts[0]);
    int y = PApplet.parseInt(parts[1]);
    leds.add(new Led(x, y, i));
  }
} 

void saveLeds() {
  //save the led positions to a file
  String[] lines = new String[leds.size()];
  for (int i = 0; i < leds.size(); i++) {
    lines[i] = leds.get(i).x + "," + leds.get(i).y;
  }
  saveStrings("leds.txt", lines);
}

class Led {
  
  int x;
  int y;
  color c;
  //static class variable
  int ledIndex;
  
  Led(int x, int y, int ledIndex) {
    this.x = x;
    this.y = y;
    this.c = color(0,0,0);
    this.ledIndex=ledIndex;
  }
  
  void draw() {
    fill(c);
    rect(x, y, 32, 32);
    fill(165);
    text(ledIndex, x+20, y+20);  
  }

}

//create animation file that displays at every frame each led in a different color
//the animation file can be loaded in the arduino sketch to display the leds in a rainbow manor
//the animation file is saved in the sketch folder as animations.txt
void createAnimationFile() {
  String[] lines = new String[leds.size()];
  for (int i = 0; i < leds.size(); i++) {
    lines[i] = "";
    for (int j = 0; j < leds.size(); j++) {
      if (i==j) {
        lines[i] += "255,0,0,";
      } else {
        lines[i] += "0,0,0,";
      }
    }
  }
  saveStrings("animations.txt", lines);
}