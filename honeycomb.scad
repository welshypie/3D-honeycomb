// Honeycomb Structure

// Honeycomb base Unit, 1 cell
// R = radius, outer radius of a cicle enclosing the cross-section hexagon
// H = height, the height of the honeycomb structure
// t = thickness, the wall thickness
module honeycombUnit(R, H, t) {

    T = t / cos(30);
    rotate([0,0,90])
    difference(){
        
        cylinder(r=R, h=H, center=false, $fn=6);
        
        translate([0,0,-1])
        cylinder(r=(R - T), h=(H + 2), center=false, $fn=6);
        
    }
}

//r = 10;
//h = 10;
//t = 2;
//tt = t/cos(30);
//ly = 3*(r-tt/2)*cos(60);
//lx = (r-tt/2)*cos(30);
//
//honeycombUnit(r, h, t);
//translate([lx, ly, 0])
//honeycombUnit(r, h, t);


// X = the number of cells in the X-direction
// Y = the number of cells in the Y-direction
// C = convexity: concave, convex, or half
// First cell is centered on origin (0, 0)
// Structure expands in +X direction, then +Y direction
module honeycombStructure(R, H, t, X, Y, C) {
    
    T = t / cos(30);
    lx = 2*(r-T/2)*cos(30);
    ly = 3*(r-T/2)*cos(60);

    union(){
        
        // Y (# in col direction)
        for (i = [0:1:Y-1])  {
            // X (# in row direction)
            
            // For Concave, Every other row has 1 fewer cells
            if (C=="concave"){
                // Even rows, create X cells
                if (i % 2 == 0) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx, i*ly, 0])
                        honeycombUnit(R, H, t);
                    }
                }
                // Odd rows, create X-1 cells
                else if (i % 2 == 1) {
                    for (ii = [0:1:X-2]) {
                        translate([ii*lx + lx/2, i*ly, 0])
                        honeycombUnit(R, H, t);
                    }
                }
            }
            
            else if (C=="half"){
                if (i % 2 == 0) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx, i*ly, 0])
                        honeycombUnit(R, H, t);
                    }
                }
                else if (i % 2 == 1) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx + lx/2, i*ly, 0])
                        honeycombUnit(R, H, t);
                    }
                }
            }
            
            else if (C=="convex"){
                if (i % 2 == 0) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx, i*ly, 0])
                        honeycombUnit(R, H, t);
                    }
                }
                else if (i % 2 == 1) {
                    for (ii = [0:1:X]) {
                        translate([ii*lx-lx/2, i*ly, 0])
                        honeycombUnit(R, H, t);
                    }
                }
            }
            
            else {
            }
            
        }
    }

}
        

r=10;
h=10;
t=2;
X=4;
Y=5;
C="convex";

honeycombStructure(r,h,t,X,Y,C);
