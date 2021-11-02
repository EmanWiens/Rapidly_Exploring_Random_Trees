/* 
 * Created by Emanuel Wiens 
 * Created on Oct 27, 2021 
 * Purpose: Implementation based on "Rapidly-Exploring Random Trees: Progress and Prospects" by Steven M. LaValle and James J. Kuffner and "Rapidly-Exploring Random Trees A New Tool for Path Planning" by Steven M. LaValle. 
 * Link: http://msl.cs.uiuc.edu/~lavalle/papers/LavKuf01.pdf
 * Link: http://msl.cs.illinois.edu/~lavalle/papers/Lav98c.pdf 
 * Calculating intercept point of two vectors: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
 */ 

final float stepSize = 25; 
final int[] obstacleSizes = new int[]{ 8, 64, 128, 512 }; 
final int numObstacles = 15; 
final float epsilon = .1; 

Node start, end; 
boolean endReached; 
ArrayList<Node> path; 
ArrayList<Obstacle> obstacles; 

void setup() {
  size(500, 500); 
  endReached = false; 
  path = new ArrayList<Node>(); 
  
  // Generate obstactes 
  obstacles = new ArrayList<Obstacle>(); 
  setupObstacles(); 
  
  generateStartAndEnd(); 
}

void draw() {
  background(255);   
  
  // if the goal is not reached, take a random step 
  if (!endReached) {
    PVector target = new PVector(random(width), random(height)); 
    step(target); 
  }
  
  // draw the current search tree 
  ArrayList<Node> queue = new ArrayList<Node>(); 
  queue.add(start); 
  Node current; 
  
  // draw the current tree 
  stroke(0); 
  fill(0);  
  while(!queue.isEmpty()) { 
    current = queue.get(0); 
    queue.remove(0); 
    
    queue.addAll(current.getNext()); 
    for (Node item : current.getNext()) { 
      line(current.getPos().x, current.getPos().y, item.getPos().x, item.getPos().y); 
    } 
  } 
  
  // draw obstacles 
  for (int i = 0; i < numObstacles; i++) { 
    obstacles.get(i).draw(); 
  } 
  
  // if the end is reached, draw the path of it 
  if (endReached) { 
    stroke(0, 255, 0); 
    Node next; 
    
    for (int i = 0; i < path.size() - 1; i++) { 
      current = path.get(i); 
      next = path.get(i + 1); 
      
      line(current.getPos().x, current.getPos().y, next.getPos().x, next.getPos().y); 
    }
  } 
  
  // draw start and end 
  fill(0, 255, 0); 
  noStroke(); 
  ellipse(start.getPos().x, start.getPos().y, 5, 5);
  
  fill(255, 0, 0);
  ellipse(end.getPos().x, end.getPos().y, 5, 5);
} 

// p1 and p2 make up line 1
boolean lineIntersect(PVector p1, PVector p2, PVector p3, PVector p4) { 
  float denom = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x); 
  if (denom == 0) return false; 
  
  float px = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / denom; 
  float py = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y- p2.y) * (p3.x * p4.y - p3.y * p4.x)) / denom; 
  PVector p = new PVector(px, py); 
  
  // test if the point is on BOTH line segments 
  return p1.dist(p) + p.dist(p2) > p1.dist(p2) - epsilon && p1.dist(p) + p.dist(p2) < p1.dist(p2) + epsilon && 
    p3.dist(p) + p.dist(p4) > p3.dist(p4) - epsilon && p3.dist(p) + p.dist(p4) < p3.dist(p4) + epsilon; 
}

void setupObstacles() { 
  PVector pos; 
  int w, h; 
  
  for (int i = 0; i < numObstacles; i++) { 
    pos = new PVector(random(width), random(height)); 
    w = obstacleSizes[(int)random(obstacleSizes.length - 1)]; 
    h = obstacleSizes[(int)random(obstacleSizes.length - 1)]; 
    
    obstacles.add(new Obstacle(i, pos, w, h)); 
  } 
} 

Obstacle intersectsObstacle(PVector current, PVector step) {
  for (Obstacle obstacle : obstacles) { 
    if (obstacle.intersects(current, step)) 
      return obstacle; 
  } 
  
  return null; 
}

Obstacle inObstacle(PVector point) {
  for (Obstacle obstacle : obstacles) { 
    if (obstacle.inBounds(point)) 
      return obstacle; 
  } 
  
  return null; 
}

void step(PVector target) {
  // find the closest node to target 
  // avoid obstacles 
  Node closest = closestNode(target); 
  PVector normDir = target.sub(closest.getPos()).normalize(); 
  Node nextStep = new Node(new PVector(closest.getPos().x + normDir.x * stepSize, closest.getPos().y + normDir.y * stepSize)); 
  
  if (intersectsObstacle(closest.getPos(), nextStep.getPos()) == null) { 
    closest.addNext(nextStep); 
  
    if (nextStep.getPos().dist(end.getPos()) < stepSize) {
      nextStep.addNext(end); 
      endReached = true; 
      
      findPath(); 
    }
  } 
} 

// depth first search 
void findPath() { 
  Node current; 
  path.add(start); 
  boolean visitNext; 
  
  while(true) { 
    current = path.get(path.size() - 1); 
    visitNext = false; 
    
    for (Node node : current.getNext()) {
      if (!node.isVisited()) {
        path.add(node); 
        visitNext = true; 
        break; 
      } 
    } 
    
    if (!visitNext) { 
      current.setVisited(); 
      path.remove(path.size() - 1); 
    } 
    
    if (current.isEnd()) { 
      path.add(current); 
      break; 
    }
  } 
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
  // make sure that the end and start is not in an obstacle 
  while (true) { 
    start = new Node(new PVector(random(width), random(height))); 
    
    if (inObstacle(start.getPos()) == null) 
      break; 
  } 
  while (true) { 
    end = new Node(new PVector(random(width), random(height))); 
    
    if (inObstacle(end.getPos()) == null) 
      break; 
  } 
  end.setAsEnd(); 
}
