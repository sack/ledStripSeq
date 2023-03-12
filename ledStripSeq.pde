
//array of leds
 ArrayList<Led> leds;
String[] frames;
boolean play = false;
Sequencer sequencer;
color colorPicker = color(0, 0, 0);

void setup() {
  size(1280, 720);  
  leds = new ArrayList<Led>();
  frameRate(10);
  loadLeds();
  sequencer= new Sequencer();
  sequencer.loadAnimation("animations7.txt");
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
      stroke(255,255,0,200);
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

  sequencer.display();
  if (play) {
    
    sequencer.nextFrame();
     
    
  }
  sequencer.displayProgressBar();

  //screen 
  fill(0);
  rect(6*32,7*32,27*32,12*32);
  fill(255);
  text("u: delete last led", 7*32, 8*32);
  text("s: save leds", 7*32, 9*32);
  text("l: load leds", 7*32, 10*32);
  text("1,2,....: load animations", 7*32, 11*32);
  text("x: create animation file", 7*32, 12*32);
  text("space: play animation", 7*32, 13*32);
  text("leds: "+leds.size(), 7*32, 14*32);

 
  text("framerate: "+frameRate, 7*32, 17*32);

  text("frame: "+sequencer.currentFrame, 17*32, 8*32);
  text("frames: "+sequencer.animations.size(), 17*32, 9*32);
  text("next frame: n", 17*32, 10*32);
  text("previous frame: p", 17*32, 11*32);

  //display color picker palette in hsb
  colorMode(HSB, 360);
  for (int i = 0; i < 360; i+=10) {
      for (int j = 0; j < 255; j+=10) {
      fill(i, 255, j);
      rect(17*32+i, 11*32+j, 10, 10);
      }
    
  }
  colorMode(RGB, 255);

  //display the selected color
  fill(colorPicker);
  rect(20*32, 8*32, 32, 32);


  






}
void mouseClicked() {
  //on click inside the color picker palette
  if (mouseX>17*32 && mouseX<17*32+360 && mouseY>11*32 && mouseY<11*32+255) {
    colorPicker = get(mouseX, mouseY);
  }else{
    //test if it in a led
    for (int i = 0; i < leds.size(); i++) {
      
        leds.get(i).click();
      
    }
    
  }
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
   if (key == '1'){
    //load the led animations from a file
    loadAnimations(1);
   }
  if (key == '2'){
    //load the led animations from a file
    loadAnimations(2);
   }
  if (key == '3'){
    //load the led animations from a file
    loadAnimations(3);
   }
  if (key == '4'){
    //load the led animations from a file
    loadAnimations(4);
   }
  if (key == '5'){
    //load the led animations from a file
    loadAnimations(5);
   }
     if (key == '6'){
    //load the led animations from a file
    loadAnimations(5);
   }

   if (key=='n'){
    sequencer.nextFrame();
   }
    if (key=='p'){
      sequencer.previousFrame();
    }

 if (key == 'x'){
  aniBars();
 }
 if (key == ' '){
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
/**/
void saveLeds() {
  //save the led positions to a file
  String[] lines = new String[leds.size()];
  for (int i = 0; i < leds.size(); i++) {
    lines[i] = leds.get(i).x + "," + leds.get(i).y;
  }
  saveStrings("leds.txt", lines);
}/**/

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
    //rect(x, y, 32, 32);
    noStroke();
    rect(x, y, 10, 10);
    fill(0,170,0);
    text(ledIndex, x+12, y+9);  
  }
  //on click on the led
  void click() {
    if (mouseX>x && mouseX<x+10 && mouseY>y && mouseY<y+10) {
      c = colorPicker;
      //read the sequencer current frame and set the led color
      
      String[] frameLeds = split(sequencer.animations.get(sequencer.currentFrame), ' ');
      println(frameLeds);
      
      ArrayList<Integer> leds = new ArrayList<>();

      for (int i = 0; i < frameLeds.length; i++) {
        String[] parts = split(frameLeds[i], ':');
        leds.add(PApplet.parseInt(parts[0]));
      }
      //if current led is in the current frame
      if (leds.contains(ledIndex)) {
        //remove the led from the current frame
        println("contains");
        println(sequencer.animations.get(sequencer.currentFrame));
        //search for the led in the current
        int idx =sequencer.animations.get(sequencer.currentFrame).indexOf(ledIndex+":");
        println(ledIndex);

        int lenled=str(ledIndex).length()+7;
        println(lenled);
        String pColor = sequencer.animations.get(sequencer.currentFrame).substring(idx, idx+lenled);
        println("-"+pColor+"-");
        sequencer.animations.set(sequencer.currentFrame, sequencer.animations.get(sequencer.currentFrame).replace(pColor, ledIndex+":"+hex(c, 6)));



      } else {
        //add the led to the current frame
        sequencer.animations.set(sequencer.currentFrame, sequencer.animations.get(sequencer.currentFrame)+" "+ledIndex+":"+hex(c, 6));
      }


      println(leds);
      println(sequencer.animations.get(sequencer.currentFrame));
      //save file
      sequencer.saveAnimation();
        

          



          //leds.get(ledIndex).c = c;
      

    }
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


//generate waves from led 8 to 13
void aniWaves()
{
  //String[] lines = new String[leds.size()];

  int fNumber = 30;
  String[] frame = new String[fNumber];
  String line = "";
  //during 30 frames
  //turn on led 8 to 13 one by one
  for(int i = 0; i < fNumber; i++)
  {
    line = "";
    for(int j = 8; j < 14; j++)
    {
      if(i == j-8)
      {
        line += j+":FFF000 ";
      }
      else
      {
        line += i+":000000 ";
      }
    }
    if (line.length() > 0)
      line = line.substring(0, line.length() - 1);
    frame[i] = line;
  }

  saveStrings("animations5.txt", frame);
}

void aniBars(){
  String[] frame= new String[26];
  int i=0;
  String line = "";
  line += setPixel(0,"00FF00");
  line +=setPixel(1,"00FF00");
  
  line +=setBar(1,1,"00FF00");
  
  line = line.substring(0, line.length() - 1);
  frame[i] = line;
   
  i++; 

  line =setBar(1,1,"00FF00");
  line +=setPixel(2,"00FF00");

  line = line.substring(0, line.length() - 1);
  frame[i] = line;
  i++; 

  line =setBar(1,2,"00FF00");
  line +=setPixel(3,"00FF00");

  line = line.substring(0, line.length() - 1);
  frame[i] = line;

  i++; 

  line =setBar(1,2,"00FF00");
  line +=setBar(6,4,"00FF00");
  line +=setPixel(4,"00FF00");

  line = line.substring(0, line.length() - 1);
  frame[i] = line;
  i++; 

  line =setBar(1,3,"00FF00");
  line +=setBar(2,3,"00FF00");
  line +=setBar(3,3,"FFFF00");
  line +=setPixel(4,"00FF00");
  line = line.substring(0, line.length() - 1);
  frame[i] = line;
  i++; 
  for (int j = 0; j < 20; j++)
  {

  line =setBar((int) random(1,3),(int) random(1,4),"00FF00");
  line +=setBar((int) random(4,6),(int) random(1,4),"00FF00");
  line +=setBar(3,3,"FFFF00");
  line +=setPixel((int) random(27,32),"00FF00");
  line = line.substring(0, line.length() - 1);
  frame[i] = line;
   i++;
  }

  
  saveStrings("animations6.txt", frame);
}

String setPixel(int i, String mycolor){
  String line = "";
  
  line += i+":"+mycolor+" ";
  
  return line;
}

String setBar(int bar,int nled, String mycolor){
  String line = "";

  if (bar == 1){
    for (int i = 8; i < 8+nled; i++){
      line += i+":"+mycolor+" ";
      
    }
  }

  if (bar == 2){
    for (int i = 14; i < 14+nled; i++){
      line += i+":"+mycolor+" ";
    }
  }
  if (bar == 3){
    for (int i = 20; i > 20+nled; i++){
      line += i+":"+mycolor+" ";
    }
  }
  if (bar == 4){
    for (int i = 42; i > 42+nled; i++){
      line += i+":"+mycolor+" ";
    }
  }
  if (bar == 5){
    for (int i = 48; i > 48+nled; i++){
      line += i+":"+mycolor+" ";
    }
  }
  if (bar == 6){
    for (int i = 54; i > 54+nled; i++){
      line += i+":"+mycolor+" ";
    }
  }
  if (bar == 7){
    for (int i = 70; i > 70+nled; i++){
      line += i+":"+mycolor+" ";
    }
  }
  //derniere a l'envers
  if (bar == 8){
    for (int i = 0 ; i > nled; i++){
      line += i-95+":"+mycolor+" ";
    }
  }
  print (line);


  return line;
}






//create animation file that displays at every frame each led in a different color
void createAnimationFile2() {
  String[] lines = new String[leds.size()];
  for (int i = 0; i < leds.size(); i++) {
     lines[i] = "";
    lines[i] += i+":FF0000";
    if (i>0) {
      lines[i] +=" "+(i-1)+":000000";
      //remove last caracter
    }
  }
  saveStrings("animations1.txt", lines);
}


class Sequencer {
  //array of animations
  ArrayList<String> animations;
  //current frame index
  int totalFrames;
  int currentFrame;

  //load animation from file
  void loadAnimation(String fileName) {
    frames = loadStrings(fileName);
    //put all frames in animations array
    animations = new ArrayList();
    for (int i = 0; i < frames.length; i++) {
      animations.add(frames[i]);
    }
    totalFrames = animations.size();
    currentFrame = 0;
  }

  //add frame to animation
  void addFrame(String line) {
    line = line.substring(0, line.length() - 1);
    animations.add(line); 
  }
  //save animation to file
  void saveAnimation() {

    //convert arraylist to array
    String[] frames = new String[animations.size()];
    for (int i = 0; i < animations.size(); i++) {
      frames[i] = (String) this.animations.get(i);
    }

    saveStrings("animations7.txt", frames);
  }

  //display current frame
  void display() {
  
   //currentFrame = frameCount%animations.size();
      String[] frameLeds = split(animations.get(currentFrame), ' ');
      for (int i = 0; i < frameLeds.length; i++) {
          String[] parts = split(frameLeds[i], ':');
          int ledIndex = PApplet.parseInt(parts[0]);
          int c = -16777216 + unhex(parts[1]);


          leds.get(ledIndex).c = c;
      }
     
    
  }

  //write led change from previous frame
  void write() {


  }

  void nextFrame() {
    currentFrame++;
    if (currentFrame >= animations.size()) {
      currentFrame = 0;
    }
  }
  void previousFrame() {
    currentFrame--;
    if (currentFrame < 0) {
      currentFrame = animations.size()-1;
    }
  }
  void displayProgressBar() {
  //diplay progress bar
      int barWidth = 1000;
      int barHeight = 10;
      int barX = 60;
      int barY = height-10;
      int barSize=barWidth/animations.size();
      fill(0);
      rect(barX, barY, barWidth-barSize*2, barHeight);
      fill(255);
      rect(map(currentFrame, 0, animations.size(), barX, barWidth), barY, barSize , barHeight);
  }


}



