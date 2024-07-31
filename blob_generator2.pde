// based on: https://discourse.processing.org/t/help-creating-organic-looking-blobs/8777
import java.util.Date;
import processing.embroider.*;

PEmbroiderGraphics E;

String fileExt = "pes"; // jef, dst, pes, svg
String projectTitle = "blobs";
String fileName;

// embroidery props
// float strokeSpacing = 3;
// float strokeWeight = 25;
// float hatchSpacing = 30;
// int threadColor = 0;

// shape props
float margin = 20;

float resolution = 13;  // Number of vertices in blob (works best from 13+)
float rad = 300;  // Radius of the blob
float x;  // X-coordinate of vertex
float y;  // Y-coordinate of vertex
float round = random(0, 100); // Roundness - the higher the number, the more elongated

float nVal; // Noise: Value
float nInt = 10; // Noise: Intensity
float nAmp = 0.4; // Noise: Amplitude
float nSeed = random(0, 1000); // Noise: Unique value

void setup() {
  noLoop();
  size(916, 916); // 4x4
  E = new PEmbroiderGraphics(this, width, height);
  draw();
}

void draw() {
  E.clear();
  background(255);
  
  Date d = new Date();
  fileName = projectTitle + "_" + d.getTime();
  E.setPath(sketchPath(fileName + "."+ fileExt));
  
  E.pushMatrix();  // Isolate placement for each individual blob (push)
  E.translate(width/2, height/2);  // Placement of blob (and movement on Y-axis)
  E.noFill();

  /* Blob shape creation */
  E.beginShape();  // Begin shape
  for (float a=-1; a <= TWO_PI; a += TWO_PI/resolution) {  // Generate points around the entire circle (TWO_PI) and distribute them based on resolution

    nVal = map(noise(cos(a)*nInt+nSeed, sin(a)*nInt+nSeed, 0), 0.0, 1.0, nAmp, 1.0);  // Map noise value to match the amplitude

    x = cos(a)*(rad+round) *nVal;  // X-coordinate of the point (radius+roundness)
    y = sin(a)*rad *nVal;  // Y-coordinate of the point

    E.curveVertex(x, y);  // Create curveVertex point based on coordinates
  }
  E.endShape(CLOSE);  // End shape

  E.popMatrix();  // Isolate placement for each individual blob (pop)
  
  // Clean up and render
  E.optimize();
  E.visualize();
}

void keyPressed() {
  if (key == ' ') {
    nSeed = random(0, 1000);  // Regenerate unique noise seed on space bar
    redraw();
  }
  if (key == 'd' || key == 'D') {
    saveEmbroidery(); // Save embroidery pattern on 'd' key press
  }

  // Arrow keys
  if (keyCode == UP) {
    rad += 10; 
    redraw();
  }
  if (keyCode == DOWN) {
    rad = max(10, rad - 10); // Radius shouldn't go below 10
    redraw();
  }
  if (keyCode == LEFT) {
    round -= 5; // Make less elongated
    redraw();
  }
  if (keyCode == RIGHT) {
    round += 5; // Make more elongated
    redraw();
  }
}

void saveEmbroidery() {
  E.endDraw();
  save(fileName + ".png");
  println("Embroidery pattern saved as " + fileName + "." + fileExt);
}
