public class SoundPoint extends Position {

    private float intensity;
    private int buffer_index;

    public Boid boid;

    // Reference to the Audio Input
    AudioInput audio_in = null;

    public SoundPoint(AudioInput reference_audio, float temp_phi, float temp_theta, float temp_radius, float temp_intensity, int temp_buffer_index) {
        super(temp_phi, temp_theta, temp_radius);
        audio_in     = reference_audio;
        intensity    = AdjustIntensity(temp_intensity);
        buffer_index = temp_buffer_index;

        boid = new Boid(phi, theta);

        render();
    }

    private float AdjustIntensity(float new_intensity) {
        // Map Intensity
        new_intensity = map(new_intensity*ADJUSTMENT_FACTOR, -1, 1, BASE_RADIUS/-3, BASE_RADIUS/3);

        // Ease Intensity
        new_intensity = ease(intensity, new_intensity);

        return new_intensity;
    }

    void render() {
        // Get the intensity from the line in and adjust
        intensity = AdjustIntensity(audio_in.left.get(buffer_index));

        // for now x=phi and y=theta
        movePosition(boid.location.x, boid.location.y, (radius + intensity));

        stroke(255);
        strokeWeight(2);

        point(x, y, z);
    }

    void renderLine(SoundPoint other_point) {
        stroke(255, 40);
        strokeWeight(1);

        line(x,y,z,other_point.x,other_point.y,other_point.z);
    }


    float ease(float old_value, float new_value) {
        // Applys a slight delay when updating a value

        new_value = old_value + ((new_value - old_value)/10);
        return new_value;
    }
}