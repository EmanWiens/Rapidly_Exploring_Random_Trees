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
    stroke(0); 
    noFill(); 
    rect(pos.x, pos.y, w, h); 
  } 
  
  public boolean inBounds(PVector point) { 
    return point.x > pos.x && point.x < pos.x + w && point.y > pos.y && point.y < pos.y + h; 
  }
}
