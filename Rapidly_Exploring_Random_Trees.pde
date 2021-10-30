/* 
Created by Emanuel Wiens 
Created in Oct 27, 2021 
Purpose: Implementation based on Rapidly-Exploring Random Trees: Progress and Prospects by Steven M. LaValle and 
  James J. Kuffner and Rapidly-Exploring Random Trees A New Tool for Path Planning by Steven M. LaValle. 
Link: http://msl.cs.uiuc.edu/~lavalle/papers/LavKuf01.pdf
Link: http://msl.cs.illinois.edu/~lavalle/papers/Lav98c.pdf 
*/ 

final float stepSize = 20; 

Node start, end; 
boolean endReached; 
ArrayList<Integer> path; 

void setup() {
  size(500, 500); 
  generateStartAndEnd(); 
  endReached = false; 
  path = new ArrayList<Integer>(); 
  
  // TODO generate obstactes 
}

void draw() {
  background(255); 
  
  // if the goal is not reached, take a random step 
  if (!endReached) {
    PVector target = new PVector(random(width), random(height)); 
    fill(0, 0, 255); 
    noStroke(); 
    ellipse(target.x, target.y, 5, 5);
    step(target); 
  }
  
  // draw the current search tree 
  ArrayList<Node> queue = new ArrayList<Node>(); 
  queue.add(start); 
  Node current; 
  
  stroke(0); 
  fill(0); 
  // draw the current tree  
  while(!queue.isEmpty()) {
    current = queue.get(0); 
    queue.remove(0); 
    
    queue.addAll(current.getNext()); 
    for (Node item : current.getNext()) { 
      line(current.getPos().x, current.getPos().y, item.getPos().x, item.getPos().y); 
    }
  } 
  
  // if the end is reached, draw the path of it 
  if (endReached) {
    stroke(0, 255, 0); 
    current = start; 
    Node prev = null; 
    
    for (int i = 0; i < path.size() - 1; i++) {
      prev = current; 
      current = current.getNext(path.get(i)); 
      
      line(prev.getPos().x, prev.getPos().y, current.getPos().x, current.getPos().y); 
    }
  }
  
  // draw start and end 
  fill(0, 255, 0); 
  noStroke(); 
  ellipse(start.getPos().x, start.getPos().y, 5, 5);
  
  fill(255, 0, 0);
  ellipse(end.getPos().x, end.getPos().y, 5, 5);
} 

void step(PVector target) {
  // find the closest node to target 
  Node closest = closestNode(target); 
  PVector normDir = target.sub(closest.getPos()).normalize(); 
  Node nextStep = new Node(new PVector(closest.getPos().x + normDir.x * stepSize, closest.getPos().y + normDir.y * stepSize)); 
  closest.addNext(nextStep); 
  
  if (nextStep.getPos().dist(end.getPos()) < stepSize) {
    nextStep.addNext(end); 
    endReached = true; 
    
    findPath(); 
  }
} 

// depth first search 
void findPath() {
  println("TODO find the path to the goal!"); 
  //ArrayList<Node> queue = new ArrayList<Node>(); 
  //queue.add(start); 
  //Node current = start; 
  //path.add(current.getNext().size() - 1); 
  
  //while(true) { 
  //  current.getNext(path.get(path.size())); 
    
  //  if (path.get(path.size() - 1) < 0 || current.getNext().size() - 1 < 0) { 
  //    path.remove(path.size() - 1);
  //  } else {
  //    path.set(path.size() - 1, path.get(path.size() - 1) - 1); 
  //  }
    
  //  if (current.isEnd()) 
  //    break; 
  //} 
}

Node closestNode(PVector target) {
  Node closest = start; 
  ArrayList<Node> queue = new ArrayList<Node>(); 
  queue.add(start); 
  Node current; 
  
  while(!queue.isEmpty()) {
    current = queue.get(0); 
    queue.remove(0); 
    
    queue.addAll(current.getNext());
    
    if (current.getPos().dist(target) < closest.getPos().dist(target)) {
      closest = current; 
    }
  }
  
  return closest; 
}

void generateStartAndEnd() {
  start = new Node(new PVector(random(width), random(height))); 
  end = new Node(new PVector(random(width), random(height))); 
  end.setAsEnd(); 
}
