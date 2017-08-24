class MaxIntSet
  def initialize(max)
    @store = Array.new(max+1) {false}
  end

  def insert(num)
    @store[num] = true if is_valid?(num)
  end

  def remove(num)
    @store[num] = false if is_valid?(num)
  end

  def include?(num)
    @store[num] if is_valid?(num)
  end

  private

  def is_valid?(num)
    raise "Out of bounds" unless num < @store.length && num >= 0
    true
  end

  def validate!(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    @store[num % num_buckets] << num unless include?(num)
  end

  def remove(num)
    @store[num % num_buckets].delete(num) if include?(num)
  end

  def include?(num)
    @store[num % num_buckets].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if @count == num_buckets
    unless include?(num)
      @store[num % num_buckets] << num
      @count += 1
    end
  end

  def remove(num)
    if include?(num)
      @store[num % num_buckets].delete(num)
      @count -= 1
    end
  end

  def include?(num)
    @store[num % num_buckets].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
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
