/*
 * Author:  Mark Hanford
 * License: Creative Commons Attribution-ShareAlike 3.0 Unported License
 *          see http://creativecommons.org/licenses/by-sa/3.0/
 * URL:     http://www.thingiverse.com/thing:172682
 */

/* [Common] */

// width of a single card
card_width = 57;

// thickness of a single card
card_thickness = 0.3;

// height of a single card
card_height = 80;

// number of cards
number_of_cards = 30;


/* [Advanced] */

// size of the front step
front_lip = 5;

// size of the back step
back_lip = 5;

// thickness of the walls of the stand
wall_thickness = 2;

// extra space around the cards
gap = 2;


/* [Hidden] */

// Show the card deck?
showCards = true;

// Shortcut for wall_thickness
t=wall_thickness;

// A tiny offset used to ensure CSG clearance and prevent coincident surface problems
j=0.01;


// Size of the actual stack of cards
stackSizeX = card_width;
stackSizeY = card_thickness * number_of_cards;
stackSizeZ = card_height;

// Calculate the major dimensions of the stand
standSizeX = stackSizeX + (t * 2) + (gap * 2);
standSizeY = stackSizeY + (t * 2) + (gap * 2);
standBackZ = stackSizeZ * 0.50;
standFrontZ = stackSizeZ * 0.33;


// The main body of the stand
module base()
{
	// Ensure that the slope doesn't cause strange artifacts on the edges
	_frontLip = max(front_lip, t);
	_backLip = max(back_lip, t);

	holeSizeX = stackSizeX + (gap * 2);
	holeSizeY = stackSizeY + (gap * 2);
	holeSizeZ = standBackZ - t;

	angle = atan((standBackZ - standFrontZ) / (standSizeY - _frontLip - _backLip));
	slopeLength = (standBackZ-standFrontZ) / sin(angle);
	slopeHeight = (standSizeY-back_lip) * sin(angle);
	stepHeight = (standBackZ-standFrontZ);

	color([0.8, 0, 0])
	difference()
	{	
		cube([standSizeX, standSizeY, standBackZ]);

		// The main hole for the cards
		translate([t, t, t])
		{
			cube([holeSizeX, holeSizeY, holeSizeZ+j]);
		}

		// The former for the slope
		if (_frontLip + _backLip >= standSizeY)
		{
			echo("Not using a slope - not enough space");
		} else {

			translate([0, _frontLip, standFrontZ])
			rotate([angle, 0, 0])
			translate([-j, 0, 0])
			cube([standSizeX+j+j, slopeLength+j, slopeHeight+j]);


			// The former to flatten the front
			translate([-j, -j, standFrontZ])
			cube([standSizeX+j+j, _frontLip+j, stepHeight+j]);
		}

	}
}


module cards()
{
	color([0.9, 0.5, 0.1, 0.8])
	translate([t, t, t+j])
	translate([gap, gap, 0])
	cube([stackSizeX, stackSizeY, stackSizeZ]);
}


translate([-standSizeX*0.5, -standSizeY*0.5, 0])
union()
{
	base();

	if (showCards)
	{
		% cards();
	}
}