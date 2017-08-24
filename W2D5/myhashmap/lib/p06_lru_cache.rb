require 'byebug'
require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count, :map, :store, :max
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map[key]
      # update_node! (@map[key])
      @store.remove(key)
      @store.append(key, @map[key])
      return @map[key]
    else
      val = @prc.call(key)
      if @store.count >= @max
        head = @store.first
        @store.remove(head.key)
        @map.delete(head.key)
      end
      @store.append(key, val)
      @map.set(key, val)
      return val
    end

  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    # @store stuff

  end

  def eject!
    @store.remove
  end
end


a = LRUCache.new(3, Proc.new { |x| x ** 2 })
a.get(2)
a.get(3)
a.get(5)
a.get(2)
a.get(3)
a.get(5)
a.get(2)
a.get(3)
a.get(5)
p a.map[2]
puts a
# a.get(4)
# puts a
# a.get(5)
# puts a
# a.get(10)
# puts a
