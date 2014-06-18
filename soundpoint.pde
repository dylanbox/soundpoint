import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;

PeasyCam pCamera;

class BeatListener implements AudioListener {
    private BeatDetect beat;
    private AudioInput source;

    public BeatListener(BeatDetect beat, AudioInput source) {
        this.source = source;
        this.source.addListener(this);
        this.beat = beat;
    }

    void samples(float[] samps) {
        beat.detect(source.mix);
    }

    void samples(float[] sampsL, float[] sampsR) {
        beat.detect(source.mix);
    }
}

class Arm {
    // An arm around the circle

    Point[] points = new Point[0];

    Arm(Point[] temp_points) {
        points = temp_points;
    }
}

class Point {
    // A point in space around the circle

    public float x, y, z;

    Point(float temp_x, float temp_y, float temp_z) {
        x = temp_x;
        y = temp_y;
        z = temp_z;
    }
}


Minim minim;
AudioInput in;
BeatDetect beat;
BeatListener bl;
float kickSize, snareSize, hatSize;

color white;

float r_1, r_2 = 250;
float theta_1, theta_2 = 0;
float phi_1, phi_2 = 0;
float x_1, y_1, x_2, y_2, z_1, z_2 = 0;
int point_size = 2;

Arm[] sphere_arms = new Arm[22];


void setup()
{
  size(600, 600, P3D);
  noSmooth();
  white = color(255);
  colorMode(HSB,100);

  pCamera = new PeasyCam(this, 300);
  pCamera.lookAt(width/2,height/2,0,150);

  minim = new Minim(this);
  // minim.debugOn();

  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);

  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(300);
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, in);

  background(0);
}

void draw()
{

  background(0);


  translate(width/2, height/2, 0);

  for(int i = 0; i < 22; i++) {

      phi_1   = map(float(i), 0, 22, 0, TWO_PI);

      Point[] arm_points = new Point[22];
      Arm arm = new Arm(arm_points);
      sphere_arms[i]=arm;

      for(int k = 0; k < 22; k++) {

           theta_1 = map(float(k), 0, 22, 0, PI);

           r_1 = map(in.left.get((i*22) + k), -1, 1, 50, 100);

           x_1 = r_1 * cos(phi_1) * sin(theta_1);
           y_1 = r_1 * sin(phi_1) * sin(theta_1);
           z_1 = r_1 * cos(theta_1);


           strokeWeight(2);
           stroke(white);
           point(x_1, y_1, z_1);

           Point sphere_point = new Point(x_1, y_1, z_1);

           arm.points[k] = sphere_point;

      }

  }

  // Draw Lines

  for(int i = 0; i < 22; i++) {

      for(int k = 0; k < 22; k++) {

           strokeWeight(1);
           stroke(white, 40);

           Point starting_point = sphere_arms[i].points[k];

           if (k > 0) {
               Point adjacent_point = sphere_arms[i].points[k-1];
               line(starting_point.x, starting_point.y, starting_point.z, adjacent_point.x, adjacent_point.y, adjacent_point.z);
            }

           if (i > 0) {
                Point neighbor_point = sphere_arms[i-1].points[k];
                line(starting_point.x, starting_point.y, starting_point.z, neighbor_point.x, neighbor_point.y, neighbor_point.z);
           } else {
                Point neighbor_point = sphere_arms[21].points[k];
                line(starting_point.x, starting_point.y, starting_point.z, neighbor_point.x, neighbor_point.y, neighbor_point.z);
           }
       }
   }

}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}


// Lines
  // for(int i = 0; i < in.bufferSize() - 1; i++) {

  //     theta_1 = map(float(i), 0, in.bufferSize(), 0, TWO_PI);
  //     theta_2 = map(float(i+1), 0, in.bufferSize(), 0, TWO_PI);

  //     r_1 = map(in.left.get(i), -1, 1, 50, 250);
  //     r_2 = map(in.left.get(i+1), -1, 1, 50, 250);

  //     // Polar to Cartesian conversion
  //     x_1 = r_1 * cos(theta_1);
  //     y_1 = r_1 * sin(theta_1);
  //     x_2 = r_2 * cos(theta_2);
  //     y_2 = r_2 * sin(theta_2);

  //     line(x_1, y_1, z_1, x_2, y_2, z_2);
  // }