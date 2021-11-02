class Obstacle { 
  private PVector pos; 
  private int w, h; 
  private int id; 
  
  public Obstacle(int id, PVector pos, int w, int h) { 
    this.pos = pos; 
    this.w = w; 
    this.h = h; 
    this.id = id; 
  } 
  
  void draw() { 
    stroke(50, 50, 200); 
     fill(50, 50, 200); 
     rect(pos.x, pos.y, w, h); 
  } 
  
  public boolean inBounds(PVector point) { 
    return point.x > pos.x && point.x < pos.x + w && point.y > pos.y && point.y < pos.y + h;
  }
  
  public boolean intersects(PVector current, PVector step) { 
    // top line 
    if (lineIntersect(current, step, pos, new PVector(pos.x + w, pos.y))) 
      return true; 
    // right line 
    if (lineIntersect(current, step, pos, new PVector(pos.x, pos.y + h))) 
      return true; 
    // bottom line 
    if (lineIntersect(current, step, new PVector(pos.x, pos.y + h), new PVector(pos.x + w, pos.y + h))) 
      return true; 
    // left line 
    if (lineIntersect(current, step, new PVector(pos.x + w, pos.y), new PVector(pos.x + w, pos.y + h))) 
      return true; 
    return false;
  }
}
