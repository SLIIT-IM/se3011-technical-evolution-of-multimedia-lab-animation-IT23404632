
int state = 0; // 0=start, 1=play, 2=end
int startTime;
int duration = 30;

// playaer
float px, py;
float pr = 20;
float step = 6;

// helper
float hx, hy;
float ease = 0.10;

// ball
float bx, by;
float br = 15;
float xs = 4, ys = 3;
boolean ballAlive = true;

// explsion
int particleCount = 25;
float[] ex = new float[particleCount];
float[] ey = new float[particleCount];
float[] evx = new float[particleCount];
float[] evy = new float[particleCount];
float[] life = new float[particleCount];
boolean exploding = false;

// score data
int score = 0;
boolean trails = false;

void setup() {
  size(700, 350);
  resetGame();
}

void draw() {

  // bg
  if (!trails) {
    background(#9DF4FF);
  } else {
    noStroke();
    fill(245, 40);
    rect(0, 0, width, height);
  }

  // start
  if (state == 0) {
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(26);
    text("CATCH THE BALL", width/2, height/2 - 40);
    textSize(18);
    text("Press ENTER to Start", width/2, height/2);
  }

  // Play
  if (state == 1) {

    int elapsed = (millis() - startTime) / 1000;
    int timeLeft = duration - elapsed;
    if (timeLeft <= 0) state = 2;

    // COntrol pad
    if (keyPressed) {
      if (keyCode == RIGHT) px += step;
      if (keyCode == LEFT)  px -= step;
      if (keyCode == DOWN)  py += step;
      if (keyCode == UP)    py -= step;
    }

    px = constrain(px, pr, width - pr);
    py = constrain(py, pr, height - pr);

    // helper monement
    hx += (px - hx) * ease;
    hy += (py - hy) * ease;

    // BALL MOVE
    if (ballAlive) {
      bx += xs;
      by += ys;

      if (bx > width - br || bx < br) xs *= -1;
      if (by > height - br || by < br) ys *= -1;

      // collioson
      if (dist(px, py, bx, by) < pr + br) {
        score++;
        startExplosion(bx, by);
        ballAlive = false;
      }
    }

    // ball
    if (ballAlive) {
      fill(#0FFA47);
      ellipse(bx, by, br*2, br*2);
    }

    // EXPLOSION
    if (exploding) {
      boolean stillAlive = false;

      for (int i = 0; i < particleCount; i++) {
        if (life[i] > 0) {
          stillAlive = true;
          ex[i] += evx[i];
          ey[i] += evy[i];
          life[i] -= 4;

          fill(#FA0F32, life[i]);
          ellipse(ex[i], ey[i], 6, 6);
        }
      }

      if (!stillAlive) {
        exploding = false;
        resetBall();
      }
    }

    // player
    fill(#0F18FA);
    ellipse(px, py, pr*2, pr*2);

    // helper
    fill(#E20FFA);
    ellipse(hx, hy, 14, 14);

    // screen
    fill(0);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Score: " + score, 20, 20);
    text("Time: " + timeLeft, 20, 40);
    text("Trails: " + (trails ? "ON" : "OFF") + " (T)", 20, 60);
  }

  // end
  if (state == 2) {
    background(240);
    textAlign(CENTER, CENTER);
    textSize(26);
    fill(0);
    text("TIME OVER", width/2, height/2 - 30);
    textSize(20);
    text("Final Score: " + score, width/2, height/2);
    text("Press R to Restart", width/2, height/2 + 40);
  }
}

void keyPressed() {
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
  }

  if (state == 2 && (key == 'r' || key == 'R')) {
    resetGame();
    state = 0;
  }

  if (key == 't' || key == 'T') {
    trails = !trails;
  }
}

// explosion start
void startExplosion(float x, float y) {
  exploding = true;

  for (int i = 0; i < particleCount; i++) {
    ex[i] = x;
    ey[i] = y;
    evx[i] = random(-4, 4);
    evy[i] = random(-4, 4);
    life[i] = 255;
  }
}

void resetBall() {
  bx = random(br, width - br);
  by = random(br, height - br);
  xs *= 1.05;
  ys *= 1.05;
  ballAlive = true;
}

void resetGame() {
  px = width/2;
  py = height/2;
  hx = px;
  hy = py;
  score = 0;
  xs = 4;
  ys = 3;
  resetBall();
}
