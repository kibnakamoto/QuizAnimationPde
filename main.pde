/*
 * A simple quiz made in processing about ECC
 * Copyright (C) 2022 Taha Canturk
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
 /* there is a warning in console that says:
 * ==== JavaSound Minim Error ====
 * ==== Don't know the ID3 code TXXX
 * ignore this warning since its just a warning
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

AudioPlayer winningSound;
AudioPlayer losingSound;
int state; // a variable for the different screens we could be on
float strokeWeight1 = 3;
float strokeWeight2 = 3;
float strokeWeight3 = 3;
boolean correct;
int gameS = 0;
float time = millis();
boolean showCRequested = false;
boolean showWRequested = false;
int clickedOn = 5;
int score = 0;
float waitTimeGame = 10000;
boolean answered = false;
boolean shot = false;
int clickCountGame = 0;
boolean whenShot = false;
float ammoX = width/10*1.4;
float ammoY = height*4.3;
float millis = millis();
float notShotAmmoY;
float notShotAmmoX;
float theta;
float v0 = 100;
float birdX = width/10*50;
float birdY = height/10*6;
boolean gameWon = false;
int timeLeft = 10;
float newMillis = millis();
float tmpMillis = millis();
float tmpMillis2 = tmpMillis;
float millisGame = millis(); // for game time
float wrongOrCorectMillis = millis(); // if correct or wrong wait time
float timeLeftTimer = millis(); // for game timer
int playedTime = -1; // how many questions player got right
int questionCount = 0; // which question player is on
PImage greenBackground;
PImage redBackground;
PImage grass; // for game
PImage startScreen;
PImage gameBackground; // for game
float calcMillis = millis();
float notShotTime = millis();
float t;
boolean gameScoreGiven = false;
int questionShuffledTime = 0;

// 10 question answer java maps(dictionaries)
java.util.Map<String, Boolean> ansQ1 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ2 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ3 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ4 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ5 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ6 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ7 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ8 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ9 = new HashMap<String, Boolean>();
java.util.Map<String, Boolean> ansQ10 = new HashMap<String, Boolean>();

// unordered nested map for question and possible answers
//java.util.Map<String,java.util.Map<String,Boolean>> // for non ordered hashmap
java.util.Map<String, java.util.Map<String,Boolean>>
questionMap = new java.util.HashMap<String, java.util.Map<String,Boolean>>();

// randomize answer order
java.util.Map<String, Boolean> randomizeAnswerOrder(java.util.Map<String, Boolean> ansQ) {
    java.util.List<String> answerList = new ArrayList<String>(ansQ.keySet());
    java.util.Map<String, Boolean> orderedMap = new java.util.LinkedHashMap<String,Boolean>();
    java.util.Collections.shuffle(answerList); // shuffle list
    for(String answers : answerList) {
        orderedMap.put(answers, ansQ.get(answers)); // put key value pair onto shuffled ordered map
    }
    return orderedMap;
}

void setup(){
  size(600, 600); // canvas size
  
  // insert images
  greenBackground = loadImage("greenBackground.jpg.jpg"); // .jpg.jpg is an accident I am too lazy to fix
  redBackground = loadImage("redBackground.jpg.jpg");
  grass = loadImage("grassBackground.jpg");
  gameBackground = loadImage("cityBackground.jpg"); //// use https://cloudconvert.com/mp3-to-wav to convert mp3 to wav. might make it work
  startScreen = loadImage("cryptographyTheme.jpg");
  
  // insert sound
  Minim minim = new Minim(this);
  winningSound = minim.loadFile("clapping-sound.mp3");
  losingSound = minim.loadFile("augh-by-garrison.mp3");
  
  state = 0; // initial state as home screen
  
  // insert questions and answers to hashmaps
  ansQ1.put("use private key generator",true); // correct answer
  ansQ1.put("use SHA-1",false);
  ansQ1.put("use public key",false);
  ansQ1.put("use text",false);
  
  ansQ2.put("secp571k1",false);
  ansQ2.put("secp256r1",false);
  ansQ2.put("DUAL_EC_DRGB",true); // correct answer
  ansQ2.put("Curve25519",false);
  
  ansQ3.put("brainpoolP384t1",false);
  ansQ3.put("P-521",true);
  ansQ3.put("brainpoolP384k1",false);
  ansQ3.put("RSA",false);
  
  ansQ4.put("y^2 = x^3−3x+b",false);
  ansQ4.put("y^2 = x^3+ax+b",false);
  ansQ4.put("x^2+y^2 = a^2+a^2x^2y^2",true);
  ansQ4.put("y^2 = x^3+x^2+x",false);
  
  ansQ5.put("128",false);
  ansQ5.put("192",false);
  ansQ5.put("224",false);
  ansQ5.put("256",true);
  
  ansQ6.put("random", true);
  ansQ6.put("reversed", false);
  ansQ6.put("real", false);
  ansQ6.put("no meaning", false);

  ansQ7.put("twisted", true);
  ansQ7.put("twitter", false);
  ansQ7.put("turn", false);
  ansQ7.put("no meaning", false);
  
  ansQ8.put("koblits", false);
  ansQ8.put("potassium", false);
  ansQ8.put("koblitz", true);
  ansQ8.put("no meaning", false);

  ansQ9.put("Keccak256", false);
  ansQ9.put("AES192", false);
  ansQ9.put("sha512", false);
  ansQ9.put("P-256", true);

  ansQ10.put("ECC is used to generate public key", true);
  ansQ10.put("ECC is used for encryption", false);
  ansQ10.put("ECDSA is used for encryption", false);
  ansQ10.put("elliptic curves are slow", false);
  
  // input questions to map
  questionMap.put("How do you generate a public key \nusing the algorithm brainpoolp512r1?", randomizeAnswerOrder(ansQ1));
  questionMap.put("Which of these algorithms by the NSA \nhave a back door installed into it?", randomizeAnswerOrder(ansQ2));
  questionMap.put("Which of these algorithms are made by\nthe Standards for Efficient Cryptography Group?", randomizeAnswerOrder(ansQ3));
  questionMap.put("Which equation is for the Edwards curve?", randomizeAnswerOrder(ansQ4));
  questionMap.put("Which ones are the recommended sizes \nfor generating a public key using ECC?", randomizeAnswerOrder(ansQ5));
  questionMap.put("What is the \"r\" in \nbrainpoolP512r1", randomizeAnswerOrder(ansQ6));
  questionMap.put("What is the \"t\" in \nbrainpoolP384t1", randomizeAnswerOrder(ansQ7));
  questionMap.put("What is the \"k\" in secp256k1", randomizeAnswerOrder(ansQ8));
  questionMap.put("Which of the following is an\nelliptic curve algorithm", randomizeAnswerOrder(ansQ9));
  questionMap.put("Which of the following is correct", randomizeAnswerOrder(ansQ10));
  
  // How to delete
  //questionMap.remove("How do you generate a public key using the algorithm brainpoolp512r1?"); // input key as parameter
  
  // How to iterate nested map
  //for(java.util.Map.Entry<String, java.util.Map<String, Boolean>> hash : questionMap.entrySet()) {
  //    println(hash);
  //}
}

// TODO: add as many more questions as possible
/* How do you generate a public key using the algorithm brainpoolp512r1? // ansQ1
 * Which of these algorithms by the NSA have a back door installed into it?  // ansQ2
 * Which of these algorithms are made by the Standards for Efficient Cryptography Group?  // ansQ3
 * Which equation is for the Edwards curve?  // ansQ4
 * Which ones are the recommended sizes for generating a public key using ECC?  // ansQ5
 * What is the \"r\" in brainpoolP512r1  // ansQ6
 * What is the \"t\" in brainpoolP384t1  // ansQ7
 * What is the \"k\" in secp256k1  // ansQ8
 * Which of the following is an elliptic curve algorithm  // ansQ9
 * Which of the following is correct  // ansQ10
 */

void drawTank() {
    fill(0, 5, 15);
    rect(width/10*.5,height/10*7.55,width/10*1.5,height/20,40); // tank base
    String amount = !shot ? "1" : "0"; // amount of shots
    push();
    
    // calculate how much time is left
    // if one second passes, increase time left variable
    if(timeLeft >= 0 && timeLeft <= 10) {
        if(playedTime == 0) {
            timeLeft = (int)(10000+10000*playedTime - millis()+timeLeftTimer) / 1000;
        } else {
            timeLeft = (int)(10000*playedTime - millis()+timeLeftTimer) / 1000;
        }
    } else {
          timeLeft = timeLeft < 0 ? timeLeft++ : timeLeft--;
    }
    
    while(timeLeft >= 11) {
        timeLeft-=10;
    }
    
    // print how much ammo is left and how much time is left
    textSize(width/35);
    text(amount + " ammo left\ntime left:" + timeLeft, width/10*7,height/10*1);
    pop();
    
    // turret
    push();
    translate(width/10*1.2,height/10*7.3);
    if(mouseY%360 <= 350 && mouseY%360 > 260) {
        rotate(radians(mouseY));
        if(mousePressed) { // if just pressed, save coordinates
            whenShot = true;
        } else {
            whenShot = false;
        }
    }
    rect(0,0,width/10*.9,height/10*.15,20);
    pop();
    
    arc(width/10*1.25,height/10*7.55,width/10*.7,height/10*.7, PI, TWO_PI); // top part
    
    // tank bottom part
    for(int c=0;c<4;c++) {
        fill(28, 29, 31);
        ellipse(width/10*.36*c+width/10*.7,height/10*7.85,width/10*.35,height/10*.35);
        fill(52, 59, 53);
        ellipse(width/10*.36*c+width/10*.7,height/10*7.85,width/10*.25,height/10*.25);
        ellipse(width/10*.36*c+width/10*.7,height/10*7.85,width/10*.15,height/10*.15);
        push();
        rectMode(CENTER);
        rect(width/10*.36*c+width/10*.7,height/10*7.85,width/10*.05,height/10*.05);
        pop();
    }
    
    
        if(!shot) {
            notShotTime = millis(); // update not shot time
            push();
            translate(width/10*1.2,height/10*7.3);
            if(mouseY%360 <= 350 && mouseY%360 > 260) {
              if(whenShot) {
                  notShotAmmoY = mouseY;
                  notShotAmmoX = mouseY;
              }
                rotate(radians(mouseY));
                fill(0xee,0,0);
                rect(0, 0, width/10*.5,height/10*.1,50);  // show x-ray of ammo in turret
            }
            pop();
        } else {
            push();
            translate(ammoX,ammoY);
            rotate(radians(notShotAmmoY));
            rect(0,0,width/10*.5,height/10*.1,50);
            pop();
            
            // reset timer every time game runs
            t = (int)(millis()-timeLeftTimer-(notShotTime-timeLeftTimer));
            while(t > 10000) { // make sure t is smaller than 10000 miliseconds
                t-=10000;
            }
            
            // calculate x and y coordinates
            theta = radians(notShotAmmoY);
            ammoX = width/10*1.5 + v0*cos(theta)*t/1000;
            //ammoY = 160 - v0*sin(theta)*t/1000 + 5*t/1000*t/1000;
            ammoY = height/10*2.66 - v0*sin(theta)*t/1000 - 5*t/1000*t/1000;
       }
}

// bird is the thing the player tries to shoot
void drawBird() {
    // body
    fill(219, 191, 29);
    ellipse(birdX,birdY,width/10,height/10*.8);
    
    // eyes
    fill(0xff,0xff,0xff);
    ellipse(birdX+width/10*.2,birdY-height/10*.1,width/10*.25,height/10*.22);
    fill(5,5,5);
    ellipse(birdX+width/10*.2,birdY-height/10*.1,width/10*.1,height/10*.09);
    
    // nose
    fill(219, 144, 22);
    triangle(birdX+width/10*.75,birdY,birdX+width/10*.45,
             birdY+height/10*.05,birdX+width/10*.45,birdY-height/10*.05);
    
    // feet
    fill(0,0,0);
    rect(birdX+width/10*.1,birdY+height/10*.4,width/10*.03,height/10*.3);
    
    push();
    noStroke();
    translate(birdX+width/10*.1,birdY+height/10*.5);
    for(int c=1;c<4;c++) {
      if(c != 3) {
          rotate(40 + 30/c);
          rect(0,0,width/10*.03,height/10*.2);
      }
    }
    pop();
    fill(0,0,0);
    rect(birdX-width/10*.2,birdY+height/10*.4,width/10*.03,height/10*.3);
    
    push();
    noStroke();
    translate(birdX-width/10*.2,birdY+height/10*.5);
    for(int c=1;c<4;c++) {
      if(c != 3) {
          rotate(40 + 30/c);
          rect(0,0,width/10*.03,height/10*.2);
      }
    }
    pop();
}


void gamePaused() {
    push();
    textAlign(CENTER);
    textSize(width/10*.5);
    fill(0,0,0);
    text("PAUSED\nPRESS ENTER TO CONTINUE",width/10*5,height/10*5);
    pop();
}

float incX = 0;
float incY = 0;

void drawGame() {
    background(#87ceeb);
    
    // draw grass
    image(grass,0,0,width,height);
    
    push();
    tint(144, 201, 240,180);
    image(gameBackground,0,0,width*1.8,height/10*8);
    pop();
    
    // add bird animation so that it moves aronud and the player has to shoot it
    if(millis() > millis+250) {
      if(birdX <= width/10*8.5 && birdX > width/10*4) {
          incX++;
      } else {
          incX-=2;
      }
      if(birdY <= height/10*6 && birdY > height/10*3) {
          incY-=1.5;
      } else {
          incY+=.5;
      }
        // reset millis
        millis = millis();
    }
    
    push();
    rotate(radians(10));
    drawBird();
    pop();
    
    // if bird shot
    if(ammoX <= birdX+width/10*1.5 &&
       ammoX >= birdX-width/10*1.5 &&
       ammoY <= birdY+height/10*.8 &&
       ammoY >= birdY-height/10*.4) {
        gameWon = true;
    }
    
    if(gameWon) {
       ammoX = -width/10*2;
       ammoY = -height/10*2;
       if(birdY <= height/10*8) {
           birdX-=.5;
           birdY+=3;
       }
       push();
       textAlign(CENTER);
       textSize(width/10*.5);
       text("Gained 100 Points!", width/10*5,height/10*5);
       if(!gameScoreGiven) {
           score+=100;
           gameScoreGiven = true;
       }
       pop();
    } else { // bird will move to evade ammo
        birdX+=incX;
        birdY+=incY;
    }
    drawTank();
}

float textSizeQuestion = width/45; // 20 when width = 800
float textSizeAns = width/53.333333; // 15 when width = 800
float[] questionStrokes = {width/50,width/50,width/50,width/50}; // 3.2 when width = 800
boolean quizStarted = false;

// simple function to make sure text fits for answer
float calcTextSizeAns(String text, float textSize) {
    int textLen = text.length();
    switch(textLen) {
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
            textSize = width/30;
            break;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
            textSize = width/35;
            break;
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
            textSize = width/40;
            break;
        default:
            textSize = width/48;
            break;        
    }
    return textSize;
}

float calcTextSizeQ(String text, float textSize) {
    int textLen = text.length();
    switch(textLen) {
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
            textSize = width/16;
            break;
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
            textSize = width/19;
            break;
        case 20:
        case 21:
        case 22:
        case 23:
        case 24:
            textSize = width/22;
            break;
        default:
            textSize = width/25;
            break;        
    }
    
    return textSize;
}

int questionDraw(String question, String ans, String wrongAns1, String wrongAns2, String wrongAns3) {
    java.util.Set<String> choices = new java.util.HashSet<String>(); // an unordered hashset is similiar to randomizing
    choices.add(ans);
    choices.add(wrongAns1);
    choices.add(wrongAns2);
    choices.add(wrongAns3);

    String[] abcd = {"a) ","b) ", "c) ", "d) "};
    String[] choicesArr = new String[4];
    float[] ansCoordinates = new float[2];
    
    // equivelant to System.arraycopy(choices.toArray(), 0, choicesArr, 0, choices.length());
    // put choices set values to an array to access using index
    int index = 0;
    for(String val : choices) {
        choicesArr[index] = val;
        index++;
    }
    
    // put question
    push();
    noStroke();
    fill(50, 141, 168);
    fill(0xff,0xff,0xff);
    textSize(calcTextSizeQ(question,textSizeQuestion));
    text(question,width/10*5,height/10*1.5);
    pop();
    
    index=0; // set index to zero
    int rightIndex = 5; // correct answer location
    push();
    stroke(1);
    textAlign(LEFT);
    for(int i=0;i<2;i++) {
        for(int j=0;j<2;j++) {
            strokeWeight(questionStrokes[index]);
            fill(197, 208, 224);
            rect(width/10*4.5*i+width/10*1,height/10*3*j+height/10*2.9,width/10*4,height/10*.8,50);
            fill(59, 55, 52);
            textSize(calcTextSizeAns(abcd[index] + choicesArr[index], textSizeAns));
            text(abcd[index] + choicesArr[index],width/10*4.5*i+width/10*1.2,height/10*3*j+height/10*3.35);
            
            // get coordinates of right answer so that the others being false is known
            if(choicesArr[index] == ans) {
              rightIndex = index;
              ansCoordinates[0] = width/10*4.5*i+width/10*1-1; // X axis
              ansCoordinates[1] = height/10*2*j+height/10*3-1; // Y axis
            }
            index++;
        }
    }
    pop();

    return rightIndex; // correct answer index
}

void drawWrongAns(String correctAns) {
    background(201, 10, 10);
    
    // add image
    image(redBackground,0,0,width,height);
    
    // play sound
    losingSound.play();
    
    fill(0xff,0xff,0xff);
    push();
    textSize(width/5);
    textAlign(CENTER);
    text("WRONG" + new String(Character.toChars(0x1F61E)),width/10*5,height/10*5); // sad emoji
    pop();
    
    // give the correct answer
    push();
    textAlign(CENTER);
    textSize(width/30);
    text("answer: " + correctAns,width/10*5,height/10*8);
    pop();
}

void drawCorrectAns() {
    background(30, 224, 20);
    
    // add image
    push();
    image(greenBackground,0,0,width,height);
    pop();
    
    // play sound
    winningSound.play();
    
    fill(0xff,0xff,0xff);
    push();
    textSize(width/20);
    textAlign(CENTER);
    text("CORRECT!",width/10*5,height/10*5);
    textSize(width/5);
    text(new String(Character.toChars(0x1F602)),width/10*5,height/10*7); // happy emoji
    pop();
}

void showCCommand() {
     background(50, 141, 168);
      // back button
      fill(0xff,0xff,0xff);
      push();
      stroke(1);
      strokeWeight(width/80);
      rect(0,height/10*5,width/10*1.5,height/10*.8,10);
      pop();
      fill(0,0,0);
      textSize(width/16);
      text("←",width/10*.5,height/10*5.6);
     push();
     textSize(width/40);
     textAlign(LEFT);
     fill(0xff,0xff,0xff);
     text("\na simple game made in processing\n" +
          "Copyright (C) 2022 Taha Canturk\n\n" +
          "This program is free software: you can redistribute\n" +
          "it and/or modify it under the terms of the GNU General\n" +
          "Public License as published by the Free Software " +
          "Foundation,\neither version 3 of the License, or (at your \n" +
          "option) any later version.\n\nThis program is\n" +
          "distributed in the hope that it will be useful, but\n" +
          "WITHOUT ANY WARRANTY; without even the implied warranty\n" +
          "of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n" +
          "See the GNU General Public License for more details.\n\n" +
          "You should have received a copy of the GNU General\n" +
          "Public License along with this program.  If not, see\n" +
          "<https://www.gnu.org/licenses/>.",width/10*1.8,height/10*1);
     pop();
}

void showWCommand() {
     background(50, 141, 168);
      // back button
      fill(0xff,0xff,0xff);
      push();
      stroke(1);
      strokeWeight(width/80);
      rect(0,height/10*5,width/10*1.5,height/10*.8,10);
      pop();
      fill(0,0,0);
      textSize(width/16);
      text("←",width/10*.5,height/10*5.6);

     push();
     textSize(width/40);
     textAlign(LEFT);
     fill(0xff,0xff,0xff);
     text("THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT\n" +
          "PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE\n" +
          "STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER\n" +
          "PARTIES PROVIDE THE PROGRAM \"AS IS\" WITHOUT WARRANTY OF\n" +
          "ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT\n" +
          "NOT LIMITED TO, THE IMPLIED WARRANTIES OF\n" +
          "MERCHANTABILITY AND FITNESS FOR A PARTICULAR\n" +
          "PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND\n" +
          "PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE\n" +
          "PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL\n" +
          "NECESSARY SERVICING, REPAIR OR CORRECTION.\n",
          width/10*1.8,height/10*3);
     pop();
}

String currentQuestion = "";
String correctAns = "";
String[] wrongAnswers = new String[3];
java.util.Map<String,Boolean> ansMap = new java.util.HashMap<String,Boolean>();
boolean waited3Seconds = false;

// a function to draw the start menu
void startMenu() {
    background(50, 141, 168);
    
    // draw background
    push();
    tint(200, 201, 240,126);
    image(startScreen, 0, 0, width, height);
    pop();
    
    textSize(20);
    push();
    fill(52, 219, 235);
    stroke(1);
    strokeWeight(strokeWeight1);
    rect(width/10*1.2,height/10*7.8,width/10*3,height/10*1);
    strokeWeight(strokeWeight2);
    rect(width/10*6,height/10*7.8,width/10*3,height/10*1);
    strokeWeight(strokeWeight3);
    rect(width/10*1.2,height/10*6,width/10*7.8,height/10*1);
    pop();
    fill(0,0,0);
    text("   START", width/10*2,height/10*8.4);
    text("   EXIT", width/10*7,height/10*8.4);
    textSize(width/40);
    text("HELP",width/10*5,height/10*6.6);
    
    textSize(width/10);
    push();
    textAlign(CENTER);
    text("Welcome\nto ECC quiz!", width/10*5,height/10*3.5);
    
    // print last score on menu
    if(score != 0) {
        text("last score: " + score, width/10*5,height/10*1);
    }
    pop();
        
    /* click start on screen, to start, exit to exit */
}

// mouse pressed function changes the state
void mouseClicked() {
  // if we are on the home screen... 
  if(state==0) {
    // check if mouse pressed on start button
     if(mouseX <= width/10*4.2 && mouseX > width/10*1.2 &&
        mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
     state = 1; // started
    }
    // check if mouse pressed on the help button
    if(mouseX <= width/10*7.8 && mouseX > width/10*1.2 &&
       mouseY > height/10*1 &&mouseY <= height/10*6) {
      state = 2; // help menu
    }
    // check if mouse pressed on the exit button
    else if(mouseX <= width/10*9 && mouseX > width/10*6 &&
            mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
      state = 3; // exit game
    }
    
  // if we are on the start screen… 
  } else if (state == 1) {
    // check buttons on the start screen
    if(mouseX > 0 && mouseX <= width/10*1.5 && mouseY > 0 && mouseY <= height/10*.8)
      state = 0;
    // quiz
    if(mouseX > width/10*4.5*0+width/10*1 && mouseX <= width/10*4.5*0+width/10*1+width/10*4 && mouseY >
       height/10*3*0+height/10*2.9 && mouseY <= height/10*3*0+height/10*2.9+height/10*.8) {
       clickedOn = 0;
   } else if(mouseX > width/10*4.5*0+width/10*1 && mouseX <= width/10*4.5*0+width/10*1+width/10*4 &&
             mouseY > height/10*3*1+height/10*2.9 && mouseY <= height/10*3*1+height/10*2.9+height/10*.8) {
       clickedOn = 1;
   } else if(mouseX > width/10*4.5*1+width/10*1 && mouseX <= width/10*4.5*1+width/10*1+width/10*4 &&
             mouseY > height/10*3*0+height/10*2.9 && mouseY <= height/10*3*0+height/10*2.9+height/10*.8) {
       clickedOn = 2;
   } else if(mouseX > width/10*4.5*1+width/10*1 && mouseX <= width/10*4.5*1+width/10*1+width/10*4 &&
             mouseY > height/10*3*1+height/10*2.9 && mouseY <= height/10*3*1+height/10*2.9+height/10*.8) {
       clickedOn = 3;
 }
  
  // if we are on the help screen
  } else if (state == 2) {
    // check buttons on the help screen
    if(mouseX > 0 && mouseX <= width/10*1.5 && mouseY > 0 && mouseY <= height/10*.8)
      state = 0;
      
    // licence
    if(mouseX > width-width/10*3 &&  mouseX <= width && mouseY > 0 && mouseY <= height/10*.8)
      link("https://www.gnu.org/licenses/gpl-3.0.en.html");
    
      // show c
    if(mouseX > width/10*3.4 && mouseX <= width/10*6.5 && mouseY > height/10*3 && mouseY <= height/10*3+height/10*.9) {
        showCRequested = true;
    }
    // show w
    if(mouseX > width/10*3.4 && mouseX <= width/10*6.5 && mouseY > height/10*4.6 && mouseY <= height/10*4.6+height/10*.9)
        showWRequested = true;
    }
    if(state == 7) {
          shot = true;
          clickCountGame++;
    }
}

int answer = 5;
boolean cont = false;

// start screen function - we can’t call this start() because that is a built in processing function
void starts() {
  background(50, 141, 168);
  fill(0xff, 0xff, 0xff);
  
  textAlign(CENTER);
    
  // back button
  push();
  stroke(1);
  strokeWeight(width/80);
  rect(0,0,width/10*1.5,height/10*.8,10);
  pop();
  fill(0,0,0);
  textSize(width/16);
  text("←",width/10*.7,height/10*.6);
  
  java.util.Set<String> wrongAnswer = new java.util.HashSet<String>();
  java.util.Iterator<java.util.Map.Entry<String,java.util.Map<String,Boolean>>> itMap = questionMap.entrySet().iterator();
  
  push();
  textAlign(CENTER);
  textSize(width/25);
  fill(0xff,0xff,0xff);
  text("score: " + score, width/10*5,height/10*.7);
  pop();
  
  // iterate nested map
  //for(java.util.Map.Entry<String, java.util.Map<String, Boolean>> questionAns : questionMap.entrySet()) {
  while (itMap.hasNext()) {
      java.util.Map.Entry<String,java.util.Map<String,Boolean>> questionAns = itMap.next();
      int index = 0;
      boolean gameStarted = millis() > time+waitTimeGame;
      if(gameS == 0) { // if game not started
          gameStarted = millis() > time+100;
      }
      // ask new question every 10 seconds
      if(gameStarted) {
          gameS++;
          currentQuestion = questionAns.getKey();
          ansMap = questionAns.getValue();
          
          // get possible answers
          for(java.util.Map.Entry<String, Boolean> map : ansMap.entrySet()) {
              if(map.getValue() == false) {
                  wrongAnswer.add(map.getKey());
                  for(int c=0;c<3;c++) {
                      if(wrongAnswers[c] == null) {
                          wrongAnswers[c] = map.getKey();
                      }
                  }
              }
              if(!(map.getValue() == false)) {
                  correctAns = map.getKey();
              }
          }
          index++;
          wrongAnswers = wrongAnswer.toArray(new String[3]);
          time = millis();
      }
      if(clickedOn != 5 && answer != 5 && !answered) { // answer = 5 if not clicked, this is to avoid error of answer not being initialized
          answered = true;
          if(answer == clickedOn) {
                // delete question
                if(questionAns.getKey() == currentQuestion)
                    itMap.remove();
                state = 5;
                clickedOn = 5;
                playedTime++;
                questionCount++;
                score+=10; // get 10 scores if got the question correct
                quizStarted = false;
                
                // reset timers for game
                millisGame = millis();
                wrongOrCorectMillis = millis();
          } else {
              // delete question
              if(questionAns.getKey() == currentQuestion)
                  itMap.remove();
               
               state = 6;
               clickedOn = 5;
               questionCount++;
               quizStarted = false;
               
               // reset timers
               millisGame = millis();
               wrongOrCorectMillis = millis();
               tmpMillis2 = millis();
          }
      } else { // timeout
          if(millis() > tmpMillis2+9997) {
                println("timeout");
                state = 6;
                
                // delete question
                if(questionAns.getKey() == currentQuestion)
                    itMap.remove();
                 clickedOn = 5;
                 //questionCount++;
                
                // reset timers
                millisGame = millis();
                wrongOrCorectMillis = millis();
                quizStarted = false;
            }
      }
     int ans = questionDraw(currentQuestion, correctAns, wrongAnswers[0], wrongAnswers[1], wrongAnswers[2]);
     if(millis() <= tmpMillis+9999) { // answer will stop updating 1 millisecond before times up 
         answer = ans;
     } else {
         clickedOn = 5;
         answered = false;
         questionShuffledTime = 0;
         
         // reset timer
         tmpMillis = millis();
         tmpMillis2 = tmpMillis;
     }
  }
  // else on the while loop
  if(questionCount == 10) {
      push();
      textAlign(CENTER);
      textSize(width/60*3);
      fill(50, 141, 168);
      rect(width/10*1.8, 0, width, height);
      
      fill(0xff,0xff,0xff);
      // tell player their score after there are no more questions
      if(playedTime < 5) {
          text("FAILED\nscore: " + score + "\ngot " + (playedTime+1) + " questions correct", width/10*5, height/10*5);
      } else if(playedTime >= 5 && playedTime < 10 && playedTime != 10) {
          text("PASSED\nscore: " + score + "\ngot " + (playedTime+1) + " questions correct", width/10*5, height/10*5);
      } else {
          text("CONGRATS\nscore: " + score + "\ngot every question correct", width/10*5, height/10*5);
      }
      pop();
  }
}

// help screen
void help(){
  background(50, 141, 168);
  fill(0xff,0xff,0xff);
  // title
  textAlign(CENTER);
  text("Help", width/2, 150);

  // back button
  push();
  stroke(1);
  strokeWeight(width/80);
  rect(0,0,width/10*1.5,height/10*.8,10);
  pop();
  fill(0,0,0);
  textSize(width/16);
  text("←",width/10*.4,height/10*.6);
  
  // link to licence
  push();
  stroke(1);
  strokeWeight(width/80);
  fill(0xff,0xff,0xff);
  rect(width-width/10*3,0,width/10*3,height/10*.8,10);
  pop();
  fill(0,0,0);
  textSize(width/20);
  text("LICENCE",width-width/10*1.8,height/10*.6);
  
  // show copying information
  push();
  stroke(1);
  rectMode(CENTER);
  strokeWeight(width/80);
  fill(0xff,0xff,0xff);
  rect(width/10*5,height/10*3.5,width/10*3,height/10*.8,10);
  pop();
  fill(0,0,0);
  textSize(width/40);
  text("SHOW C",width/10*5,height/10*3.6);

  // show warranty information
  push();
  stroke(1);
  rectMode(CENTER);
  strokeWeight(width/80);
  fill(0xff,0xff,0xff);
  rect(width/10*5,height/10*5.1,width/10*3,height/10*.8,10);
  pop();
  fill(0,0,0);
  textSize(width/40);
  text("SHOW W",width/10*5,height/10*5.2);
  if(showCRequested) {
      showCCommand();
      state = 4;
  } else if(showWRequested) {
      showWCommand();
      state = 4;
  }
  
  // instructions
  push();
  fill(0xff,0xff,0xff);
  textAlign(LEFT);
  text("you get 10 seconds for answering but try to answer as fast as possible\nplay the game when you get the\nquestion right by aiming low and far right", width/10*1, height/10*8);
  pop();
}

void mouseMoved() {
    // start
    if(mouseX <= width/10*4.2 && mouseX > width/10*1.2 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
       strokeWeight1 = 1.5;
    } else {
       strokeWeight1 = 3;
    }
    
    // exit
    if(mouseX <= width/10*9 && mouseX > width/10*6 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
       strokeWeight2 = 1.5;
    } else {
       strokeWeight2 = 3;
    }
    
    // help
    if(mouseX <= width/10*9 && mouseX > width/10*1.2 &&
       mouseY > height/10*6 && mouseY <= height/10*7) {
       strokeWeight3 = 1.5;
    } else {
       strokeWeight3 = 3;
    }
    
    // question borders
    if(state == 1) {
        if(mouseX > width/10*4.5*0+width/10*1 && mouseX <= width/10*4.5*0+width/10*1+width/10*4 &&
           mouseY > height/10*3*0+height/10*2.9 && mouseY <= height/10*3*0+height/10*2.9+height/10*.8) {
            if(questionStrokes[0] > 1)
                  questionStrokes[0]-=.1;
        } else {
            if(questionStrokes[0] < width/150)
                questionStrokes[0]+=.1;
        }
        if(mouseX > width/10*4.5*0+width/10*1 && mouseX <= width/10*4.5*0+width/10*1+width/10*4 &&
           mouseY > height/10*3*1+height/10*2.9 && mouseY <= height/10*3*1+height/10*2.9+height/10*.8) {
            if(questionStrokes[1] > 1)
                  questionStrokes[1]-=.1;
        } else {
            if(questionStrokes[1] < width/150)
                questionStrokes[1]+=.1;
        }
        if(mouseX > width/10*4.5*1+width/10*1 && mouseX <= width/10*4.5*1+width/10*1+width/10*4 &&
           mouseY > height/10*3*0+height/10*2.9 && mouseY <= height/10*3*0+height/10*2.9+height/10*.8) {
            if(questionStrokes[2] > 1)
                  questionStrokes[2]-=.1;
        } else {
            if(questionStrokes[2] < width/150)
                questionStrokes[2]+=.1;
        }
        if(mouseX > width/10*4.5*1+width/10*1 && mouseX <= width/10*4.5*1+width/10*1+width/10*4 &&
           mouseY > height/10*3*1+height/10*2.9 && mouseY <= height/10*3*1+height/10*2.9+height/10*.8) {
            if(questionStrokes[3] > 1)
                  questionStrokes[3]-=.1;
        } else {
            if(questionStrokes[3] < width/150)
                questionStrokes[3]+=.1;
        }

    }
}

void mousePressed() {
  if(state == 0) {
    // start
    if(mouseX <= width/10*4.2 && mouseX > width/10*1.2 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
        if(mouseButton == LEFT) {
            state = 1;
        }
    }
    
    // help
    if(mouseX <= width/10*9 && mouseX > width/10*1.2 &&
       mouseY > height/10*6 && mouseY <= height/10*7) {
        state = 2;   
    }
    
    // exit
    if(mouseX <= width/10*9 && mouseX > width/10*6 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
        if(mouseButton == LEFT) {
            state = 3;
        }
    }
  }
}

void keyPressed() {
    if(state == 7) {
        if(keyCode == ENTER) {
            if(looping) {
                gamePaused();
                noLoop();
            } else {
                loop();
            }
        }
    }
    
    if(state == 0) {
        if(keyCode == ESC || key == 'e') {
            state = 3;
        }
    }
}

void draw(){
  if(state != 7) { // reset timer for timer on game if state not on game
      timeLeftTimer = millis();
  }

  
  //state = 7; // to test game
   textAlign(LEFT);  // somehow centers
  // check states (screens) and run the appropriate function to draw that screen
  if (state == 0) {
    startMenu();
  } else if (state == 1) {
    starts();
  } else if (state == 2) {
    help();
  } else if (state == 3) {
    exit(); // exits the program (in your code, you want this to occur when the esc key is pressed as well)
  } else if(state == 4) {
       if(mousePressed && mouseX > 0 && mouseX <= width && mouseY > 0 && mouseY <= height) {
           showCRequested = false;
           showWRequested = false;
       }
       state = 2;
  } else if(state == 5) { // correct answer
      if(millis() <= wrongOrCorectMillis+3000) {
          drawCorrectAns();
      } else {
          winningSound.pause();
          winningSound.rewind();
          state = 7; // start game
          wrongOrCorectMillis = millis();
      }
  } else if(state == 6) { // wrong answer
      if(millis() <= wrongOrCorectMillis+3000) {
          drawWrongAns(correctAns);
      } else {
          losingSound.pause(); // pause sound
          losingSound.rewind(); // restart sound
          state = 1;
          wrongOrCorectMillis = millis();
      }
  } else if(state == 7) {
        // draw game for 10 seconds
        if(millis() <= timeLeftTimer+10000) {
            drawGame();
        } else {
            tmpMillis2 = millis()-100; // subtract by 100 since gamePlayed-100 if gameS = 0
            
            // reset values for game
            millisGame = millis();
            shot = false;
            clickCountGame = 0;
            whenShot = false;
            v0 = 100;
            birdX = width/10*7;
            birdY = height/10*5;
            gameWon = false;
            incX = 0;
            incY = 0;
            state = 1;
            ammoX = width/10*1.4;
            ammoY = height*4.3;
            gameScoreGiven = false;
      }
  }
}

/* if you do not answer the question in time, the question will reappear later on */