// Thickness of the base (mm)
T = 4;

// Thickness of the top (mm)
TT = 8;

// Angle (in degree) of the camera (0 = pointing to bottom, 35 =
// pointing near the middle of the jaws, 90 = pointing straight
// forward)
ANGLE = 35;

// ---- REFERENCES ----

// This part requires the STL for the jaw parts if you want to display
// it. But it's optional. It is recommended if you adjust this design.
module jaw() {
  translate([-36, 0, -9]) rotate([90, 180, 180]) scale(1000) color("#ccc")
    import("vendor/Fixed_Jaw.STL", convexity=5);
  translate([-56, 0, 15.4]) rotate([90, 180, 0]) scale(1000) color("#ccc")
    import("vendor/Moving Jaw.STL", convexity=5);
}

// Basic approximation of the vinmooog camera
module vinmooog() {
  l=70.3; // length of the camera case
  w=26.5; // width of the camera case
  t=20.3; // thickness of the camera case
  h=15; // hole exterior radius
  r=18.4; // camera exterior radius
  color("#cccccc") translate([0, 0, -t]) {
    translate([0, 0, t]) cylinder(1.6, r/2, r/2, $fn=16);
  }
  color("#444444") translate([0, 0, -t]) {
    translate([0, 0, t]) cylinder(3.2, r/2*.9, r/2*.9, $fn=16);
    difference() {
      translate([0, w/2+5, t/2]) rotate([90]) cylinder(5, h/2, h/2, $fn=16);
      translate([0, w/2+6, t/2]) rotate([90]) cylinder(7, h/2*.7, h/2*.7, $fn=16);
    }
    hull() {
      translate([-(l-w)/2, 0, 0]) cylinder(t, w/2, w/2, $fn=16);
      translate([(l-w)/2, 0, 0]) cylinder(t, w/2, w/2, $fn=16);
    }
    translate([-20, 10, -5]) cylinder(5, 2, 2, $fn=16);
  }
  // Line of sight
  color("red") translate([0, 0, 500]) cylinder(1000, .4, .4, center=true);
  // Angle of view (tan(<angle>/2))
  color("#ff000011") translate([0, 0, 500]) cylinder(1000, 0, 1000*tan(40/2), center=true);
}

// ---- CORE ----

module pin(l) {
  r=1.8;
  r2=r*1.016;
  translate([0, l, 0]) rotate([90]) cylinder(l, r, r, $fn=16);
  translate([0, l, 0]) rotate([90]) sphere(r2, $fn=16);
}

module base_case() {
  r=T/2;
  // Starting from the bottom up to the camera arm
  hull() {
    translate([-19, 24+r, 0]) cylinder(30,r,r,$fn=16);
    translate([-31, 24+r, 0]) cylinder(30,r,r,$fn=16);
  }
  hull() {
    translate([r-1, 16, 0]) cylinder(30,r,r,$fn=16);
    translate([-19, 24+r, 0]) cylinder(30,r,r,$fn=16);
  }
  hull() {
    translate([r-1, -16, 0]) cylinder(30,r,r,$fn=16);
    translate([r-1, 16, 0]) cylinder(30,r,r,$fn=16);
  }
  hull() {
    translate([-19, -24-r, 0]) cylinder(30,r,r,$fn=16);
    translate([r-1, -16, 0]) cylinder(30,r,r,$fn=16);
  }
  hull() {
    translate([-51+r, -24-r, 0]) cylinder(8,r,r,$fn=16);
    translate([-26, -24-r, 0]) cylinder(8,r,r,$fn=16);
  }
  hull() {
    translate([-35, -24-r, 0]) cylinder(14,r,r,$fn=16);
    translate([-26, -24-r, 0]) cylinder(14,r,r,$fn=16);
  }
  hull() {
    translate([-30, -24-r, 0]) cylinder(22,r,r,$fn=16);
    translate([-26, -24-r, 0]) cylinder(22,r,r,$fn=16);
  }
  hull() {
    translate([-26, -24-r, 0]) cylinder(30,r,r,$fn=16);
    translate([-19, -24-r, 0]) cylinder(30,r,r,$fn=16);
  }
}

module case_hole() {
  scale([-1, 1, 1]) translate([-4, -.35, 15.4]) rotate([0,90]) cylinder(15, 5, 5, $fn=32);
}

module case() {
  difference() {
    union() {
      base_case();
      translate([-23, -25, 25.87]) pin(3);
      translate([-23, -25, 4.87]) pin(2);
      translate([-48, -25, 4.87]) pin(2);
      translate([-26.9, 25, 25.87]) rotate([0,0,180]) pin(3);
      translate([-26.9, 25, 4.87]) rotate([0,0,180]) pin(2);

      scale([-1, 1, 1]) {
        union() {
          translate([0, -.35, 15.4]) rotate([0,90]) cylinder(2, 7, 7, $fn=32);
          translate([2, -.35, 15.4]) rotate([0,90]) cylinder(1, 7, 6, $fn=32);
        }
      }
    }
    case_hole();
  }
}

module support_arm() {
  r=TT/2;
  // Tolerance for the camera casing
  s=.1;
  difference() {
    union() {
      hull() {
        translate([-35, -24-T/2, r]) cube([32, .1, 2*r], center=true);
        translate([-35, -35, r]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
      }
      hull() {
        translate([-35, -35, r]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
        translate([-35, -95, 0]) rotate([ANGLE]) translate([0, r+s, -r-13-s]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
      }
      translate([-35, -95, 0]) rotate([ANGLE]) {
        difference() {
          union() {
            hull() {
              translate([0, r+s, -r-13-s]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
              translate([0, r+s, r+10]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
            }
            hull() {
              translate([0, r+s, -r-13-s]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
              translate([0, -r-s-20.3, -r-13-s]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
            }
            hull() {
              translate([0, -r-s-20.3, -r-13-s]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
              translate([0, -r-s-20.3, r+10]) rotate([0, 90]) cylinder(32, r, r, $fn=16, center=true);
            }
          }
          translate([0, -10, -19.65]) translate([0, 0, -TT/2]) cylinder(2*TT, 7.8, 7.8);
          translate([0, 7+TT/2, 0]) rotate([90]) cylinder(2*TT, 9.5, 9.5);
        }
      }
    }
  }
}

module full() {
    case();
    support_arm();
}

rotate([0, -90, 0]) {
  full();

  // Uncomment to see the jaw
  // jaw();

  // Uncomment to see the camera and the line of the sight
  // translate([-35, -95, 0]) rotate([ANGLE-90, 0, 0]) vinmooog();
}
