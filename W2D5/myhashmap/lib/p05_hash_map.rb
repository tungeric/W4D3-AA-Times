require_relative 'p02_hashing'
require_relative 'p04_linked_list'
require 'byebug'
class HashMap
  attr_reader :count
  include Enumerable

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    resize! if @count == num_buckets
    list = bucket(key)
    if list.include?(key)
      list.update(key, val)
    else
      @count += 1
      list.append(key, val)
    end
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    if include?(key)
      bucket(key).remove(key)
      @count -= 1
    end
  end

  def each(&prc)
    @store.each do |linked_lists|
      linked_lists.each do |node|
        prc.call(node.key, node.val)
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    # new_store = @store.flatten
    # @store = Array.new(2*num_buckets) { LinkedList.new }
    # @count = 0
    # new_store.each { |el| insert(el) }
    new_store = []
    self.each {|k,v| new_store << [k,v] }
    @count = 0
    @store = Array.new(2*num_buckets) { LinkedList.new }
    new_store.each { |keyvalues| set(keyvalues.first, keyvalues.last) }

  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    @store[key.hash % num_buckets]
  end
end

# a = HashMap.new
# a.set(:first, "mom")
# a.set(:first, "bob")
# a.set(:next, 5)
# a.set(:hi, "six")
# a.set(:joe, true)
# a.set(:fry, "french")
# a.set(:asdf, "asdf")
# a.set(:yay, true)
# a.set(:pop, "poop")
# a.set(:why, "how")
# a.set(:seven, 6)
# puts a
# a.delete(:next)
# puts "-------"
# puts a
