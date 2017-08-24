require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(el)
    resize! if @count == num_buckets
    unless include?(el)
      @store[el.hash % num_buckets] << el
      @count += 1
    end
  end

  def remove(el)
    if include?(el)
      @store[el.hash % num_buckets].delete(el)
      @count -= 1
    end
  end

  def include?(el)
    @store[el.hash % num_buckets].include?(el)
  end

  private

  def [](el)
    # optional but useful; return the bucket corresponding to `el`
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_store = @store.flatten
    @store = Array.new(2*num_buckets) { Array.new }
    @count = 0
    new_store.each { |el| insert(el) }
  end
end
