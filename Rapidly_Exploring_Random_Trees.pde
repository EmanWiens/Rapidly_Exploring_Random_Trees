/* 
 * Created by Emanuel Wiens 
 * Created in Oct 27, 2021 
 * Purpose: Implementation based on Rapidly-Exploring Random Trees: Progress and Prospects by Steven M. LaValle and 
 *   James J. Kuffner and Rapidly-Exploring Random Trees A New Tool for Path Planning by Steven M. LaValle. 
 * Link: http://msl.cs.uiuc.edu/~lavalle/papers/LavKuf01.pdf
 * Link: http://msl.cs.illinois.edu/~lavalle/papers/Lav98c.pdf 
 */ 

final float stepSize = 25; 
final int[] obstacleSizes = new int[]{ 32, 64, 256 }; 
final int numObstacles = 25; 

Node start, end; 
boolean endReached; 
ArrayList<Node> path; 
ArrayList<Obstacle> obstacles; 

void setup() {
  size(500, 500); 
  endReached = false; 
  path = new ArrayList<Node>(); 
  // frameRate(1); 
  
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
    fill(0, 0, 255); 
    noStroke(); 
    ellipse(target.x, target.y, 5, 5);
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
  
  if (inObstacle(nextStep.getPos()) == null) {
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
