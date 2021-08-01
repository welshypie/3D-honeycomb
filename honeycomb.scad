// Honeycomb
//
// A simple script to easily create different honeycomb structures of varying size, number of cells, and convexity


// R = radius, outer radius of a cicle enclosing the cross-section hexagon
// Radius reaches to the outer vertices of the hexagon
//
// H = height, the height of the honeycomb structure
// t = thickness, the wall thickness
module honeycombCell(R, H, t, fill=false) {

    // Length of the inner vertex to the outer vertex
    T = t / cos(30);
    
    // Create one cell and orient it
    rotate([0,0,90])
    difference(){
        
        cylinder(r=R, h=H, center=false, $fn=6);
        
        if (fill==false) {
            translate([0,0,-1])
            cylinder(r=(R - T), h=(H + 2), center=false, $fn=6);
        }
        
    }
}

// R = radius, outer radius of a cicle enclosing the cross-section hexagon
//      Radius reaches to the outer vertices of the hexagon
// H = height, the height of the honeycomb structure
// t = thickness, the wall thickne
// X = the number of cells in the X-direction
// Y = the number of cells in the Y-direction
// C = convexity: concave, convex, or stagger
// Center of first cell is centered on origin (0, 0)
// Structure expands in +X direction, then +Y direction
module honeycombStructure(R, H, t, X, Y, C, fill=false) {
    
    // Length of inner vertex to outer vertex
    T = t / cos(30);
    // Distance to translate cells in the X direction
    lx = 2*(R-T/2)*cos(30);
    // Distance to translate cells in the Y direction
    ly = 3*(R-T/2)*cos(60);

    union(){
        
        // Y (# in col direction)
        for (i = [0:1:Y-1])  {
            
            // X (# in row direction)
            // For Concave, Every odd row has 1 fewer cells (first row is even)
            if (C=="concave"){
                // Even rows, create X cells
                if (i % 2 == 0) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx, i*ly, 0])
                        honeycombCell(R, H, t, fill);
                    }
                }
                // Odd rows, create X-1 cells
                else if (i % 2 == 1) {
                    for (ii = [0:1:X-2]) {
                        translate([ii*lx + lx/2, i*ly, 0])
                        honeycombCell(R, H, t, fill);
                    }
                }
            }
            
            // For stagger, every row has the same number of cells, giving a "staggered" look
            else if (C=="stagger"){
                // Even rows, create X cells
                if (i % 2 == 0) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx, i*ly, 0])
                        honeycombCell(R, H, t, fill);
                    }
                }
                // Odd rows, create X cells
                else if (i % 2 == 1) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx + lx/2, i*ly, 0])
                        honeycombCell(R, H, t, fill);
                    }
                }
            }
            
            // For Convex, every odd row has 1 extra cell to fill both sides (first row is even)
            else if (C=="convex"){
                // Even rows, create X cells
                if (i % 2 == 0) {
                    for (ii = [0:1:X-1]) {
                        translate([ii*lx, i*ly, 0])
                        honeycombCell(R, H, t, fill);
                    }
                }
                // Odd rows, create X+1 cells
                else if (i % 2 == 1) {
                    for (ii = [0:1:X]) {
                        translate([ii*lx-lx/2, i*ly, 0])
                        honeycombCell(R, H, t, fill);
                    }
                }
            }
            
            else {
                // ???
            }
            
        }
    }

}
        
// Example 1
honeycombStructure(10,10,2,2,3,"convex", fill=true);

// Example 2
translate([60,0,0])
honeycombStructure(20,20,4,5,3,"concave");

// Example 3
translate([0,80,0])
honeycombStructure(5,5,1,3,5,"stagger");
