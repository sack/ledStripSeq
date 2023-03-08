
//array of leds
ArrayList<Led> leds;
String[] frames;
boolean play = false;

void setup() {
  size(1280, 720);  
  leds = new ArrayList<Led>();
  frameRate(10);
  loadLeds();
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
      stroke(255, 255, 0, 200);
      line(leds.get(i).x+5, leds.get(i).y+5, leds.get(i-1).x+5, leds.get(i-1).y+5);
    }
  }
  //draw a line between the current led and the mouse 
  if (leds.size()>0) {
    ////line(leds.get(leds.size()-1).x+16, leds.get(leds.size()-1).y+16, mouseX, mouseY);
    //line(leds.get(leds.size()-1).x, leds.get(leds.size()-1).y, mouseX, mouseY);
    //fill(0, 32);
    //rect(mouseX, mouseY,32,32);
  }
  if (play) {
    //display the leds in the current frame

    String[] frameLeds = split(frames[frameCount%frames.length], ' ');
    for (int i = 0; i < frameLeds.length; i++) {
      String[] parts = split(frameLeds[i], ':');
      int ledIndex = PApplet.parseInt(parts[0]);
      int c = -16777216 + unhex(parts[1]);


      leds.get(ledIndex).c = c;
    }
  }

  //screen 
  fill(0);
  rect(6*32, 7*32, 27*32, 12*32);
  fill(255);
  text("u: delete last led", 7*32, 8*32);
  text("s: save leds", 7*32, 9*32);
  text("l: load leds", 7*32, 10*32);
  text("1,2,....: load animations", 7*32, 11*32);
  text("x: create animation file", 7*32, 12*32);
  text("space: play animation", 7*32, 13*32);
  text("leds: "+leds.size(), 7*32, 14*32);


  text("framerate: "+frameRate, 7*32, 17*32);
}
void mouseClicked() {
  //create a new led
  /*
   leds.add(new Led(mouseX,mouseY,leds.size()));
   */
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
  if (key == 'l') {
    //load the led positions from a file
    loadLeds();
  } 
  if (key == '1') {
    //load the led animations from a file
    loadAnimations(1);
  }
  if (key == '2') {
    //load the led animations from a file
    loadAnimations(2);
  }
  if (key == '4') {
    //load the led animations from a file
    loadAnimations(4);
  }

  if (key == 'x') {
    //load the led animations from a file
    animCompute();
  }
  if (key == ' ') {
    //load the led animations from a file
    play = !play;
  }
}

void loadAnimations(int animationNumber) {
  //load the leds animations from a file

  frames = loadStrings("animations"+animationNumber+".txt");
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
    this.c = color(0, 0, 0);
    this.ledIndex=ledIndex;
  }

  void draw() {
    fill(c);
    //rect(x, y, 32, 32);
    noStroke();
    rect(x, y, 10, 10);
    fill(0, 170, 0);
    text(ledIndex, x+12, y+9);
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
  saveStrings("animations1.txt", lines);
}



void animCompute()
{
  //String[] lines = new String[leds.size()];

  int fNumber = 200;
  String[] frame = new String[fNumber];
  String line = "";
  int ledOn;
  int ledOff ;



  for (int fr = 0; fr<fNumber; fr++)
  {
    line = "";
    ledOn = (int)random(leds.size());
    ledOff =(int)random(leds.size());
    print("ledOn " + ledOn + "ledOff " +ledOff+"\n"); 
    for (int i = 0; i < leds.size(); i++)
    {
      if (i==ledOn)
      {
        line += i+":FFF000 ";
      } 
      if (i==ledOff)
      {
        line += i+":000000 ";
      }
    }
    print(line.length() );
    line = line.substring(0, line.length() - 1);
    frame[fr] = line;
  }


  saveStrings("animations4.txt", frame);
}



















//create animation file that displays at every frame each led in a different color
void createAnimationFile2() {
  String[] lines = new String[leds.size()];
  for (int i = 0; i < leds.size(); i++) {
    lines[i] = "";
    lines[i] += i+":FF0000";
    if (i>0) {
      lines[i] +=" "+(i-1)+":000000";
    }
  }
  saveStrings("animations1.txt", lines);
}

//create animation file that displays at every frame each led in a different color
// each led are indexed and we can have diffenrent led numbers in each frame