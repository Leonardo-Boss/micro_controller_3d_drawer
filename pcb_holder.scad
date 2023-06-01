$fn = 50;

// rounded edge
module roundededge(height, radius) {
	difference() {
		cube([radius, radius, height]);
		cylinder(height, radius, radius);
		}
	}

// rounded corner
module roundedcorner(radius) {
	difference() {
		cube(radius);
		sphere(radius);
		}
	}

// part dimensions
wall_thiccness = 4;
wall_height = 11;
wall_length = 28.466;

// outer face dimensions
front_wall_thicness = 2.2;
front_wall_extra = 2;
front_wall_height = wall_height+front_wall_extra;
front_wall_lenght = wall_length+front_wall_extra*2;

//inner face dimensions
inner_wall_thicness = 1.7;
inner_wall_length = front_wall_lenght;
inner_wall_height = wall_height;
inner_wall_xoffset = (inner_wall_length - front_wall_lenght)/2;
rounded_border_radius = 1;
module front_face() {
	// outer face
	difference(){
		cube([front_wall_lenght, front_wall_thicness, front_wall_height]);
		translate(v = [rounded_border_radius, rounded_border_radius, 0]) 
		rotate([0,0,180])
		roundededge(height = front_wall_height, radius = rounded_border_radius);
		translate(v = [front_wall_lenght-rounded_border_radius, rounded_border_radius, 0]) 
		rotate([0,0,-90])
		roundededge(height = front_wall_height, radius = rounded_border_radius);
		translate(v = [front_wall_lenght, rounded_border_radius, front_wall_height-rounded_border_radius]) 
		rotate([90,0,-90])
		roundededge(height = front_wall_lenght, radius = rounded_border_radius);
		}

	// middle part
	translate([(front_wall_lenght-wall_length)/2, front_wall_thicness, 0])
		cube([wall_length, wall_thiccness, wall_height]);

	// inner face
	translate ([-inner_wall_xoffset, wall_thiccness+front_wall_thicness,0])
		cube([inner_wall_length, inner_wall_thicness, inner_wall_height]);
}


// arduino info

arduino_length = 36;
arduino_width = 19;

// drawer
drawer_height = 7;
drawer_length = arduino_length;
drawer_width = arduino_width;
drawer_bottom_width = 10;
drawer_thiccness = 1.4;
drawer_inner_wall_x_offset = 17.166;
drawer_right_wall_x_offset = (drawer_thiccness+drawer_width-drawer_inner_wall_x_offset);
drawer_back_wall_length = drawer_right_wall_x_offset+drawer_inner_wall_x_offset+drawer_thiccness;
drawer_bottom_thiccness = 2;

module drawer() {
	// +x wall
	translate([drawer_width+drawer_thiccness, inner_wall_thicness, 0]) 
		cube([drawer_thiccness, drawer_length, drawer_height]);
	// -x wall
	translate([0, inner_wall_thicness, 0]) 
		cube([drawer_thiccness, drawer_length, drawer_height]);
	// +y wall
	translate([0,drawer_length+inner_wall_thicness,0]) 
		difference() {
			cube([drawer_back_wall_length, drawer_thiccness, drawer_height]);
			translate(v = [drawer_back_wall_length-rounded_border_radius, drawer_thiccness-rounded_border_radius, 0]) 
				roundededge(height = drawer_height, radius = rounded_border_radius);
			translate(v = [rounded_border_radius,drawer_thiccness-rounded_border_radius,0]) 
				rotate([0,0,90]) 
					roundededge(height = drawer_height, radius = rounded_border_radius);
			}
	// -y wall
	difference() {
		cube([drawer_back_wall_length, inner_wall_thicness, drawer_height]);
		translate(v = [rounded_border_radius,rounded_border_radius,0]) 
			rotate([0,0,180]) 
				roundededge(height = drawer_height, radius = rounded_border_radius);
		translate(v = [drawer_back_wall_length-rounded_border_radius,rounded_border_radius,0]) 
			rotate([0,0,-90]) 
				roundededge(height = drawer_height, radius = rounded_border_radius);
		}
	// bottom
	translate([drawer_width/2-drawer_bottom_width/2+drawer_thiccness, inner_wall_thicness, 0]) 
	cube([drawer_bottom_width, drawer_length, drawer_bottom_thiccness]);
}

// p2 connection
p2_outer_diameter = 8.4;
p2_outer_depth = 6;
p2_inner_radius = 6/2;
p2_outer_wall_thicness = 1.4;
p2_inner_thicness = 2.2;
p2_height = wall_height-1;
r = 1.5;
r2 = r;

module p2() {
	union() {
		// rounding edges
		difference() {
			cube([p2_outer_diameter, p2_outer_depth, p2_height]);
		
			translate(v = [r2, 0, p2_height-r2]) 
				rotate(a = [-90,-180,0]) 
				roundededge(height = p2_outer_depth, radius = r2);

			translate(v = [p2_outer_diameter-r2, 0, p2_height-r2]) 
				rotate(a = [270,-90,0]) 
				roundededge(height = p2_outer_depth, radius = r2);

			translate(v = [0, p2_outer_depth-r, p2_height-r]) 
				rotate(a = [-90, 180, -90]) 
				roundededge(height = p2_outer_diameter, radius = r);

			translate(v = [p2_outer_diameter-r, p2_outer_depth-r, 0]) 
				roundededge(height = p2_height, radius = r);

			translate(v = [r, p2_outer_depth-r]) 
				rotate([0,0,90])
				roundededge(height = p2_height, radius = r);

			translate(v = [p2_outer_diameter-r,p2_outer_depth-r,p2_height-r]) 
				roundedcorner(radius = r);

			translate(v = [r,p2_outer_depth-r,p2_height-r]) 
				rotate([0,0,90])
				roundedcorner(radius = r);
		}

			
		translate(v = [p2_outer_diameter/2, p2_outer_depth+p2_inner_thicness, p2_height-p2_outer_diameter/2]) 
			rotate(a = [90,0,0]) 
				cylinder(p2_outer_depth+p2_inner_thicness, p2_inner_radius, p2_inner_radius);

	translate(v = [p2_outer_diameter/2, p2_outer_depth, p2_height-p2_outer_diameter/2]) 
	rotate([-90,0,0])
	rounded_circle_edge(radius = p2_inner_radius , radius_curve = 0.5, height = p2_outer_depth);
	}
}


module rounded_circle_edge(radius, radius_curve, height=1) {
	rotate_extrude(angle = 360, convexity = 2) 
		translate([radius, 0, 0])
		difference() {
			translate([0, -height+radius_curve, 0])
				square([radius_curve, height]);
			translate([radius_curve,radius_curve,0])
				circle(radius_curve);
		}
	}


// arduino info
usb_height = 4.5;
usb_length=9.5;
usb_sticking_edge = 2;
usb_cavity_width = 13.5;
usb_cavity_height = p2_height;
usb_cavity_depth = 6.194;
usb_to_p2_distance = 4.084;
arduino_thicness = 1.5;
// usb_port
module usb() {
	union() {
			difference() {
					cube([usb_cavity_width, usb_cavity_depth, usb_cavity_height]);
					
					translate([usb_cavity_width-r, usb_cavity_depth-r, 0])
						roundededge(usb_cavity_height, r);

					translate([r, usb_cavity_depth-r, 0])
						rotate([0, 0, 90])
							roundededge(usb_cavity_height, r);

					translate([r, 0, usb_cavity_height-r])
						rotate([-90,180,0])
							roundededge(usb_cavity_depth, r);

					translate([usb_cavity_width-r, 0, usb_cavity_height-r])
						rotate([-90,270,0])
							roundededge(usb_cavity_depth, r);

					translate([0, usb_cavity_depth-r, usb_cavity_height-r])
						rotate([0,90,0]) rotate([0, 0, 90])
							roundededge(usb_cavity_width, r);
					
					translate([usb_cavity_width-r, usb_cavity_depth-r, usb_cavity_height-r])
						roundedcorner(r);

					translate([r, usb_cavity_depth-r, usb_cavity_height-r])
						rotate([0, 0, 90])
							roundedcorner(r);
				}
			translate(v = [(usb_cavity_width-usb_length)/2, 0, drawer_bottom_thiccness+arduino_thicness]) 
			difference() {

				cube([usb_length, usb_sticking_edge+usb_cavity_depth, usb_height]);

				translate([r, 0, usb_height-r])
					rotate([-90, 180, 0])
					roundededge(usb_sticking_edge+usb_cavity_depth, r);

				translate([usb_length-r, 0, usb_height-r])
					rotate([-90, 270, 0])
					roundededge(usb_sticking_edge+usb_cavity_depth, r);

				translate([r, 0, r])
					rotate([-90, 90, 0])
					roundededge(usb_sticking_edge+usb_cavity_depth, r);

				translate([usb_length-r, 0, r])
					rotate([-90, 0, 0])
					roundededge(usb_sticking_edge+usb_cavity_depth, r);
				}
		}
	}

// main
difference() {
	union() {
		front_face();

		// drawer
		translate([(usb_x_offset+usb_cavity_width/2)-drawer_back_wall_length/2, wall_thiccness+front_wall_thicness, 0])
			drawer();

	}
	// p2_cutout
	p2_x_offset = (front_wall_lenght-wall_length)/2+wall_length-p2_outer_diameter-p2_outer_wall_thicness;
	translate([p2_x_offset,0,0])
		p2();

	// usb_cutou
	usb_x_offset = p2_x_offset-usb_to_p2_distance-usb_cavity_width;
	translate([usb_x_offset, 0, 0])
		usb();
}
