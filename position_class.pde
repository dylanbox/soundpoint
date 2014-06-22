public class Position {
    // Polar Points
    public float phi   = 0;
    public float theta = 0;
    public float r     = 0;

    // Cartesian Points
    public float x = 0;
    public float y = 0;
    public float z = 0;

    Position(float temp_phi, float temp_theta, float temp_r){
        phi   = temp_phi;
        theta = temp_theta;
        r     = temp_r;

        movePosition(phi, theta, r);
    }

    void movePosition(float new_phi, float new_theta, float new_r) {
        // Converts from cartesian to polar points

        x = new_r * cos(new_phi) * sin(new_theta);
        y = new_r * sin(new_phi) * sin(new_theta);
        z = new_r * cos(new_theta);
    }

}