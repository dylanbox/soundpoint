import processing.opengl.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;


int   NUM_POINTS        = 512;
float ADJUSTMENT_FACTOR = 5;
float BASE_RADIUS       = 150;

Minim minim;
AudioInput AUDIO_IN;

PeasyCam pCamera;

color white;
color background_color = color(0, 0, 0);

Flock flock;

SoundPoint[] sound_points = new SoundPoint[NUM_POINTS];

void setup()
{
    size(600, 600, P3D);

    noSmooth();
    white = color(255);
    colorMode(RGB,255);

    pCamera = new PeasyCam(this, 600);
    pCamera.lookAt(width/2,height/2,0,300);

    minim = new Minim(this);
    // get a line in from Minim, default bit depth is 16
    AUDIO_IN = minim.getLineIn(Minim.STEREO, 512);

    flock = new Flock();

    for(int i=0; i < NUM_POINTS; i++){
        SoundPoint new_point = new SoundPoint(AUDIO_IN, random(0.0, TWO_PI), random(0.0, TWO_PI), BASE_RADIUS, 0, i);
        flock.addBoid(new_point.boid);
        sound_points[i] = new_point;
    }

    background(background_color);
}

void draw()
{
    background(0);
    translate(width/2, height/2, 0);

    flock.run();

    for(int i=0; i < NUM_POINTS; i++){
        sound_points[i].render();

        // if (i==0) {
        //     println("Phi: "+sound_points[i].boid.location.x);
        //     println("Theta: "+sound_points[i].boid.location.y);
        // }

        for(int j=0; j < NUM_POINTS; j++){
            if (dist(sound_points[i].x, sound_points[i].y, sound_points[i].z, sound_points[j].x, sound_points[j].y, sound_points[j].z) < 20) {
                sound_points[i].renderLine(sound_points[j]);
            }
        }

    }
}


void stop()
{
  // always close Minim audio classes when you are done with them
  AUDIO_IN.close();
  minim.stop();
  super.stop();
}