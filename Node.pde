class Node {
  private PVector pos; 
  private ArrayList<Node> next; 
  private boolean isEnd; 
  
  public Node(PVector pos) {
    this.pos = pos; 
    this.next = new ArrayList<Node>(); 
    isEnd = false; 
  } 
  
  public PVector getPos() { return pos; } 
  public ArrayList<Node> getNext() { return next; } 
  public Node getNext(int i) { return next.get(i); } 
  public void addNext(Node next) { this.next.add(next); } 
  public void setAsEnd() { isEnd = true; } 
  public boolean isEnd() { return isEnd; }
}
