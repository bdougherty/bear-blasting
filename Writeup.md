# Bear Blasting
By Brad Dougherty

## How to Play the Game:

The object of the game is to launch the bear and hit all of the salmon. The bear can be dragged from side to side. The blast is controlled with the arrow keys: left and right move it to the left and right, and up and down increase and decrease the power of the blast. There is a cheat that allows you to go to the next level, although you do not score any points (ctrl-up arrow), because it was primarily used for testing the levels.

## What Went Right

I had no problem manipulating the bear and the salmon on the screen, or dealing with the collisions. (In fact the collisions donʼt really need to be very precise).

## What Went Wrong

I really donʼt like the way the blast translates into motion, but I couldnʼt find a better implementation (with some sort of equation). The other thing that gave me trouble was copying the 2D array that contains the item information. Apparently, using `splice()` on the entire array doesnʼt copy any arrays inside that array. So you have to iterate through and copy each array using `splice()`;

## Design Decisions

The `HitManager` is basically a dumb class, it is told what to do by the document class. This is to make it easier to redraw each level. The `BearManager` class handles the details of whether a level is completed or not, which it determines when the bear hits the bottom. This is because it is the critical element that is controlled by the user. The keyboard control is in its own class just to separate it from the rest of the code.

## Level Designer

I made a level designer to make it easier to add levels, since they are in the XML file. This way, I donʼt have to manually put in all of the X and Y positions of every salmon on the screen. The scaling doesnʼt work perfectly, but itʼs good enough. I designed 16 levels to go with the game for now, but more can be easily added to the XML file.
