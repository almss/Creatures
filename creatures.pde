class Creature {
  PVector position;
  PVector velocity;
  PVector acceleration;

  float maxSpeed = 4.0; 
  float maxForce = 0.1; 

  Creature(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,position);
    desired.normalize();
    desired.mult(maxSpeed);
    
    PVector steer = PVector.sub(desired,velocity);
    steer.normalize();
    steer.mult(maxForce);
    return steer;
  }
  
  PVector separate(ArrayList<Creature> allCreatures) {
    float sepRadius = 40;
    
    PVector sum = new PVector();
    int count = 0;

    for(Creature other: allCreatures) {
      float distance = PVector.dist(position,other.position);
      
      if(distance > 0 && distance < sepRadius) {
        PVector diff = PVector.sub(position,other.position);
        diff.normalize();
        
        sum.add(diff);
        count++;
      }
    }
        
    if(count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector();
    }
  }
  
  PVector align(ArrayList<Creature> allCreatures) {
    float alignRadius = 60;
    
    PVector sum = new PVector();
    int count = 0;
  
    for(Creature other: allCreatures) {
      float distance = PVector.dist(position,other.position);
      
      if(distance > 0 && distance < alignRadius) {
        sum.add(other.velocity);
        count++;
      }
    }
        
    if(count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector();
    }
  }
  
  PVector cohere(ArrayList<Creature> allCreatures) {
    float cohereRadius = 60;
    
    PVector sum = new PVector();
    int count = 0;
    
    for(Creature other: allCreatures) {
      float distance = PVector.dist(position,other.position);
      
      if(distance > 0 && distance < cohereRadius) {
        sum.add(other.position);
        count++;
      }
    }
        
    if(count > 0) {
      sum.div(count);
      
      return seek(sum);
    } else {
      return new PVector();
    }
  }
  
  void applyBehaviours(PVector target, ArrayList<Creature> creatures) {
    PVector seekForce = seek(target);
    PVector sepForce = separate(creatures);
    PVector alignForce = align(creatures);
    PVector cohereForce = cohere(creatures);
    
    seekForce.mult(0.7);
    sepForce.mult(4);
    alignForce.mult(1);
    cohereForce.mult(1);
    
    applyForce(seekForce);
    applyForce(sepForce);
    applyForce(alignForce);
    applyForce(cohereForce);
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);

    position.add(velocity);

    checkEdges();

    acceleration.mult(0);
  }
  
  void display() {
    int creatureX = 20;
    int creatureY = 20;
    int creatureRadius = 10;
    
    strokeWeight(2);
    stroke(0);
    fill(0, 0, 255);
    

    pushMatrix();
    
    if (mousePressed == true) {
      fill(0, 255, 0);
    }
    else {
      fill(0, 0, 255);
    }

    translate(position.x, position.y);
    rotate(velocity.heading() + PI/2);

    ellipse(0, 0, 20, 20);
    
    
    popMatrix();
  }

  void checkEdges() {
    if (position.x > width) {
      position.x = 0;
    }

    if (position.y > height) {
      position.y = 0;
    }

    if (position.x < 0) {
      position.x = width;
    }

    if (position.y < 0) {
      position.y = height;
    }
  }
}
