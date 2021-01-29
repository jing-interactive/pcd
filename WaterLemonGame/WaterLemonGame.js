//Collision detection - Bouncing behavior

var circles;

function setup() {
  createCanvas(480, 960);

  circles = new Group();

  for (var i=0; i<20; i++)
  {
    var circle = createSprite(random(0, width), random(0, height));
    circle.addAnimation('normal', 'assets/asterisk_circle0006.png', 'assets/asterisk_circle0008.png');
    circle.setCollider('circle', -2, 2, 55);
    circle.setSpeed(random(2, 3), random(0, 360));

    //scale affects the size of the collider
    circle.scale = random(0.5, 1);
    //mass determines the force exchange in case of bounce
    circle.mass = circle.scale;
    //restitution is the dispersion of energy at each bounce
    //if = 1 the circles will bounce forever
    //if < 1 the circles will slow down
    //if > 1 the circles will accelerate until they glitch
    //circle.restitution = 0.9;
    circles.add(circle);
  }
}



function draw() {
  background(255, 255, 255);

  //circles bounce against each others and against boxes
  circles.bounce(circles);

  //all sprites bounce at the screen edges
  for (var i=0; i<allSprites.length; i++) {
    var s = allSprites[i];
    if (s.position.x<0) {
      s.position.x = 1;
      s.velocity.x = abs(s.velocity.x);
    }

    if (s.position.x>width) {
      s.position.x = width-1;
      s.velocity.x = -abs(s.velocity.x);
    }

    if (s.position.y<0) {
      s.position.y = 1;
      s.velocity.y = abs(s.velocity.y);
    }

    if (s.position.y>height) {
      s.position.y = height-1;
      s.velocity.y = -abs(s.velocity.y);
    }
  }

  drawSprites();
}
