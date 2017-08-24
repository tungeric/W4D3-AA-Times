require 'prime'
require 'byebug'
# Our hashing logic: indx * prime[indx] + element * prime[indx]
class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    sum = 0
    primes = Prime.first(self.length)
    each_with_index do |val, indx|
      hash_value = val
      hash_value = val.hash unless val.is_a?(Fixnum)
      sum += indx * primes[indx] + hash_value * primes[indx]
    end
    sum.hash
  end
end

def primes(num)
  arr = []
  i = 2
  until arr.length == num
    arr << i if is_prime?(i)
    i += 1
  end
end

def is_prime?(num)
  (2...num).none? {|n| num % n == 0 }
end

class String
  def hash
    array = self.chars.map { |char| char.ord }
    array.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    hash_arr = self.sort_by { |key, val| key }
    hash_arr.hash
  end
end
