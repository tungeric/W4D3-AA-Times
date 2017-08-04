require 'byebug'

def range(start, finish)
  return [] if finish <= start
  [start, *range(start+1, finish)]
end

def exp1(b, n)
  return 1 if n == 0
  b * exp1(b, n.pred)
end

def exp2(b, n)
  return 1 if n.zero?
  return b if n == 1

  if n.even?
    evens_half_n = exp2(b, n / 2)
    evens_half_n * evens_half_n
  else
    odds_half_n = exp2(b, n.pred / 2)
    odds_half_n * odds_half_n * b
  end
end

class Array
  def deep_dup
    return self.dup if self.none? { |el| el.is_a?(Array) }
    self.map do |el|
      if el.is_a?(Array)
        el.deep_dup
      else
        el
      end
    end
  end
end

def fibo_iter(n)
  result_arr=[1,1]
  until result_arr.length >= n
    result_arr << result_arr.last(2).inject(:+)
  end
  result_arr.first(n)
end

def fibo_recur(n)
  return [1, 1].first(n) if n <= 2
  prev_fib = fibo_recur(n.pred)
  prev_fib << prev_fib.last(2).inject(:+)
end

def subsets(arr)
  return [[]] if arr.empty?
  exclusive_subsets = subsets(arr[0...-1])
  inclusive_subsets = exclusive_subsets.map do |sub_arr|
    sub_arr += [arr[-1]]
  end
  exclusive_subsets + inclusive_subsets
end

def permutations(arr)
  return [arr] if arr.length <= 1
  result_arr=[]
  arr.each do |el|
    exclusive_arr = arr.dup
    exclusive_arr.delete(el)
    result_arr += permutations(exclusive_arr).map do |perm|
      #debugger
      perm += [el]
    end
  end
  result_arr
end

def bsearch(arr, target)
  middle = arr.length / 2
  return middle if arr[middle] == target
  return nil if arr.empty?
  if target < arr[middle]
    bsearch(arr[0...middle], target)
  else
    right_half = bsearch(arr[middle.next..-1], target)
    right_half.nil? ? nil : middle + 1 + right_half
  end
end

def merge_sort(arr)
  return arr if arr.length <= 1
  middle = arr.length / 2
  merge(merge_sort(arr[0...middle]), merge_sort(arr[middle..-1]))
end

def merge(arr1, arr2)
  merged_arr = []
  until arr1.empty? || arr2.empty?
    if arr1.first < arr2.first
      merged_arr << arr1.shift
    else
      merged_arr << arr2.shift
    end
  end
  merged_arr + arr1 + arr2
end

def greedy_make_change(amount,coins=[25,10,5,1])
  return [] if amount == 0
  new_coin = coins.find { |coin| coin <= amount }
  [new_coin] + greedy_make_change(amount - new_coin, coins)
end

def make_better_change(amount, coins)
  valid_coins = coins.reject {|coin| coin > amount}
  return [] if amount == 0

  results = []

  valid_coins.each_with_index do |coin, idx|
    results[idx] = [coin] + make_better_change(amount - coin, valid_coins[idx..-1])
  end

  results.min_by(&:length)
end

if __FILE__ == $0
  p make_better_change(24, [10,7,1])
end
