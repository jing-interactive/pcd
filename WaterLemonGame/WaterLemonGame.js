//Collision detection - Bouncing behavior

var circles;
var images = [];

function preload() {
  images[0] = loadImage('assets/snow.png');
  images[1] = loadImage('assets/yeti.png');
  images[2] = loadImage('assets/sivi.png');
  images[3] = loadImage('assets/magician.png');
  images[4] = loadImage('assets/angel.png');
}

function explosion(collector, collected)
{
  //collector is another name for asterisk
  //show the animation
  // collector.changeAnimation('stretch');
  // collector.animation.rewind();
  //collected is the sprite in the group collectibles that triggered
  //the event
  collected.life = random(60);
}

function addCircle(x, y) {
    var circle = createSprite(x, y);
    img = images[int(random(0, 5))];
    circle.addImage('normal', img); 
    // circle.addImage('normal', 'assets/snow.png');
    circle.scale = random(0.3, 0.4);
    var w = img.width * circle.scale * 0.8;
    var h = img.height * circle.scale * 0.8;

    circle.setCollider('circle', -w, -h, sqrt(w*w+h*h));
    circle.setSpeed(random(4, 8), 90);

    //scale affects the size of the collider
    //mass determines the force exchange in case of bounce
    circle.mass = circle.scale;
    //restitution is the dispersion of energy at each bounce
    //if = 1 the circles will bounce forever
    //if < 1 the circles will slow down
    //if > 1 the circles will accelerate until they glitch
    circle.restitution = 0.5;
    circles.add(circle);

    circles.overlap(circles, explosion);
}

function setup() {
  createCanvas(480, 960);

  circles = new Group();

  for (var i=0;i<10;i++)
    addCircle(random(0, width), random(0, height));
}

function mousePressed() {
  addCircle(mouseX, mouseY);
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
