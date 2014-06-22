public class Position {
    // Polar Points
    public float phi    = 0;
    public float theta  = 0;
    public float radius = 0;

    // Cartesian Points
    public float x = 0;
    public float y = 0;
    public float z = 0;

    Position(float temp_phi, float temp_theta, float temp_radius){
        phi    = temp_phi;
        theta  = temp_theta;
        radius = temp_radius;

        movePosition(phi, theta, radius);
    }

    void movePosition(float new_phi, float new_theta, float new_radius) {
        // Converts from cartesian to polar points

        x = new_radius * cos(new_phi) * sin(new_theta);
        y = new_radius * sin(new_phi) * sin(new_theta);
        z = new_radius * cos(new_theta);
    }

}