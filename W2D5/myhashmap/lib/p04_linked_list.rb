class Node
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = nil
    @tail = nil
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head
  end

  def last
    @tail
  end

  def empty?
    @head.nil?
  end

  def get(key)
    self.each { |node| return node.val if node.key == key}
    nil
  end

  def include?(key)
    !get(key).nil?
  end

  def append(key, val)
    node = Node.new(key, val)
    if empty?
      @tail = node
      @head = node
    else
      @tail.next = node
      node.prev = @tail
      @tail = node
    end
  end

  def update(key, value)
    self.each { |node| return node.val = value if node.key == key}
  end

  def remove(key)
    self.each do |node|
      if node.key == key
        if node == @head && node == @tail
          @head = nil
          @tail = nil
        elsif node == @head
          node.next.prev = nil
          @head = node.next
        elsif node == @tail
          node.prev.next = nil
          @tail = node.prev
        else
          node.prev.next = node.next
          node.next.prev = node.prev
        end
        return node.val
      end
    end
  end

  def each(&prc)
    node = @head
    until node.nil?
      prc.call(node)
      node = node.next
    end
    self
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
