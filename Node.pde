class Node {
  private PVector pos; 
  private ArrayList<Node> next; 
  private boolean isEnd; 
  private boolean visited; 
  
  public Node(PVector pos) { 
    this.pos = pos; 
    this.next = new ArrayList<Node>(); 
    isEnd = false; 
    visited = false; 
  } 
  
  public PVector getPos() { return pos; } 
  public ArrayList<Node> getNext() { return next; } 
  public Node getNext(int i) { return next.get(i); } 
  public void addNext(Node next) { this.next.add(next); } 
  public void setAsEnd() { isEnd = true; } 
  public boolean isEnd() { return isEnd; } 
  public void setVisited() { visited = true; } 
  public boolean isVisited() { return visited; } 
}
