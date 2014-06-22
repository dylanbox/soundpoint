public class SoundPoint extends Position {

    private float intensity;
    private int buffer_index;

    // Reference to the Audio Input
    AudioInput audio_in = null;

    public SoundPoint(AudioInput reference_audio, float temp_phi, float temp_theta, float temp_r, float temp_intensity, int temp_buffer_index) {
        super(temp_phi, temp_theta, temp_r);
        audio_in     = reference_audio;
        intensity    = AdjustIntensity(temp_intensity);
        buffer_index = temp_buffer_index;
        render();
    }

    private float AdjustIntensity(float new_intensity) {
        // Map Intensity
        new_intensity = map(new_intensity*ADJUSTMENT_FACTOR, -1, 1, -75, 75);

        // Ease Intensity
        new_intensity = ease(intensity, new_intensity);

        return new_intensity;
    }

    void render() {
        // Get the intensity from the line in and adjust
        intensity = AdjustIntensity(audio_in.left.get(buffer_index));

        movePosition(phi, theta, (r + intensity));

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