import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;

PeasyCam pCamera;

int GRID_SIZE = 22;

Minim minim;
AudioInput in;
BeatDetect beat;
BeatListener bl;


float ADJUSTMENT_FACTOR = 2;
float BREAK_FACTOR = 0.05;
float r = 250;
float theta = 0;
float phi= 0;
float x, y, z, intensity = 0;

color white;

color background_color = color(0, 0, 0);
int background_brightness = 0;

int line_opacity = 40;
int point_weight = 2;

boolean is_grid = true;

Row[] sound_rows = new Row[GRID_SIZE];

void setup()
{
  size(600, 600, P3D);
  noSmooth();
  white = color(255);
  colorMode(RGB,255);
  blendMode(ADD);

  // pCamera = new PeasyCam(this, 300);
  // pCamera.lookAt(width/2,height/2,0,150);

  pCamera = new PeasyCam(this, 600);
  pCamera.lookAt(width/2,height/2,0,300);

  minim = new Minim(this);
  // minim.debugOn();

  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);

  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(300);
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, in);


  // Fill in default values to sound_rows
    for(int i = 0; i < GRID_SIZE; i++) {
        Point[] row_points = new Point[GRID_SIZE];
        Row row_new = new Row(row_points);

        for(int k = 0; k < GRID_SIZE; k++) {
            Point sound_point = new Point(0,0,0,0);
            row_new.points[k] = sound_point;
        }

        sound_rows[i] = row_new;
    }

    background(background_color);
}

void draw()
{

    // if ( beat.isKick() ) {
    //     background_brightness += 10;
    // }
    // if ( beat.isSnare() ) {
    //     background_brightness += 5;
    // }

    // if (background_brightness > 30) {
    //     background_brightness = 30;
    // }

    // background_color = color(0,0, background_brightness);
    // background(background_color);

    // if (background_brightness > 0) {
    //     background_brightness -= 1;
    // }

    background(0);



  if (is_grid == true) {
      translate((width-(GRID_SIZE-1)*(GRID_SIZE-1))/2, (width-(GRID_SIZE-1)*(GRID_SIZE-1))/2, 0);
  }
  else {
      translate(width/2, height/2, 0);
  }


  // Draw Spherical Points

  for(int i = 0; i < GRID_SIZE; i++) {

      phi   = map(float(i), 0, GRID_SIZE, 0, TWO_PI);

      Point[] row_points = new Point[GRID_SIZE];
      Row row_new = new Row(row_points);

      for(int k = 0; k < GRID_SIZE; k++) {


            intensity = in.left.get((i*GRID_SIZE) + k);

            if (is_grid == true) {
                // Cartesian Coord.
                x = i*GRID_SIZE;
                y = k*GRID_SIZE;
                z = map(intensity*ADJUSTMENT_FACTOR, -1, 1, 0, 300);
            }
           else {
               // Spherical Coord.
               theta = map(float(k), 0, 21, 0, PI);
               r = map(intensity*ADJUSTMENT_FACTOR, -1, 1, 100, 400);

               x = r * cos(phi) * sin(theta);
               y = r * sin(phi) * sin(theta);
               z = r * cos(theta);
           }


           // Easing points
           x = sound_rows[i].points[k].x + ((x - sound_rows[i].points[k].x)/10);
           y = sound_rows[i].points[k].y + ((y - sound_rows[i].points[k].y)/10);
           z = sound_rows[i].points[k].z + ((z - sound_rows[i].points[k].z)/10);
           intensity = sound_rows[i].points[k].intensity + ((intensity - sound_rows[i].points[k].intensity)/10);

           Point sound_point = new Point(x, y, z, intensity);


           row_new.points[k] = sound_point;

      }

      sound_rows[i]=row_new;


  }

  // Draw Lines

  for(int i = 0; i < GRID_SIZE; i++) {

      for(int k = 0; k < GRID_SIZE; k++) {


           Point starting_point = sound_rows[i].points[k];

            point_weight = (is_broken(starting_point.intensity)) ? 0:2;
            stroke(white);
            strokeWeight(point_weight);
            point(starting_point.x, starting_point.y, starting_point.z);

            strokeWeight(1);



            if (k > 0) {
                Point adjacent_point = sound_rows[i].points[k-1];
                line_opacity = (is_broken(starting_point.intensity) || is_broken(adjacent_point.intensity)) ? 0:60;
                stroke(white, line_opacity);
                line(starting_point.x, starting_point.y, starting_point.z, adjacent_point.x, adjacent_point.y, adjacent_point.z);
            }
            if (i > 0) {
                Point neighbor_point = sound_rows[i-1].points[k];
                line_opacity = (is_broken(starting_point.intensity) || is_broken(neighbor_point.intensity)) ? 0:60;
                stroke(white, line_opacity);
                line(starting_point.x, starting_point.y, starting_point.z, neighbor_point.x, neighbor_point.y, neighbor_point.z);

            }
            else if (i == 0 && is_grid == false) {
                Point neighbor_point = sound_rows[21].points[k];
                line_opacity = (is_broken(starting_point.intensity) || is_broken(neighbor_point.intensity)) ? 0:60;
                stroke(white, line_opacity);
                line(starting_point.x, starting_point.y, starting_point.z, neighbor_point.x, neighbor_point.y, neighbor_point.z);
            }
        }
    }
}

void keyPressed() {
  if (is_grid == true) {
    is_grid = false;
  } else {
    is_grid = true;
  }
}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}

boolean is_broken(float intensity) {
    if (abs(intensity) > BREAK_FACTOR) {
       return true;
    }
    else {
       return false;
    }
}

// Lines
  // for(int i = 0; i < in.bufferSize() - 1; i++) {

  //     theta = map(float(i), 0, in.bufferSize(), 0, TWO_PI);
  //     theta_2 = map(float(i+1), 0, in.bufferSize(), 0, TWO_PI);

  //     r = map(in.left.get(i), -1, 1, 50, 250);
  //     r_2 = map(in.left.get(i+1), -1, 1, 50, 250);

  //     // Polar to Cartesian conversion
  //     x = r * cos(theta);
  //     y = r * sin(theta);
  //     x_2 = r_2 * cos(theta_2);
  //     y_2 = r_2 * sin(theta_2);

  //     line(x, y, z, x_2, y_2, z_2);
  // }