ArrayList<Creature> creatures;
int creatureCount = 60;

PVector mouseVector;

void setup() {
  size(960, 540);
  creatures = new ArrayList<Creature>();

  for (int i = 0; i < creatureCount; i++) {
    creatures.add(new Creature(random(width), random(height)));
  }

  mouseVector = new PVector(0, 0);
}

void draw() {
  background(196);

  updateMouseVector(); 

  for (Creature c : creatures) {
    c.applyBehaviours(mouseVector, creatures);
    c.update();
    c.display();
  }
}

void keyPressed() {
  if (key == 'r') {
    setup();
  }
}

void updateMouseVector() {
  mouseVector.set(mouseX, mouseY);
}
