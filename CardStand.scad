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
number_of_cards = 40;


/* [Advanced] */

// size of the front step
front_lip = 4;

// size of the back step
back_lip = 4;

// thickness of the walls of the stand
wall_thickness = 2;

// extra space around the cards
gap = 2;


/* [Hidden] */

// Show the card deck?
showCards = false;

// Shortcut for wall_thickness
t=wall_thickness;


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
	holeSizeZ = stackSizeZ;

	angle = atan((standBackZ - standFrontZ) / (standSizeY - _frontLip - _backLip));

	color([0.8, 0, 0])
	difference()
	{	
		cube([standSizeX, standSizeY, standBackZ]);

		// The main hole for the cards
		translate([t, t, t])
		{
			cube([holeSizeX, holeSizeY, holeSizeZ]);
		}

		// The former for the slope
		if (t + _frontLip + _backLip + t >= standSizeY)
		{
			echo("Not using a slope - not enough space");
		} else {
			translate([0, _frontLip, standFrontZ])
			rotate([angle, 0, 0])
			translate([-1, 0, 0])
			cube([standSizeX+2, 1000, 1000]);

			// The former to flatten the front
			translate([-1, -1, standFrontZ])
			cube([standSizeX+2, _frontLip+1, standBackZ-standFrontZ]);
		}

	}
}


module cards()
{
	color([0.9, 0.5, 0.1, 0.8])
	translate([t, t, t])
	translate([gap, gap, 0])
	cube([stackSizeX, stackSizeY, stackSizeZ]);
}


translate([-standSizeX*0.5, -standSizeY*0.5, 0])
union()
{
	base();

	if (showCards)
	{
		cards();
	}
}