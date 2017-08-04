require 'byebug'

class Array

  def my_each(&prc)
    i=0
    while i < self.length
      prc.call(self[i])
      i+=1
    end
    self
  end

  def my_select(&prc)
    result = []
    self.my_each {|el| result << el if prc.call(el)}
    result
  end

  def my_reject(&prc)
    result = []
    self.my_each {|el| result << el if !prc.call(el)}
    result
  end

  def my_any?(&prc)
    self.my_each {|el| return true if prc.call(el)}
    false
  end

  def my_all?(&prc)
    self.my_each {|el| return false if !prc.call(el)}
    true
  end

  def my_flatten
    result = self.to_s.chars.reject { |el| "[], ".include?(el) }.map(&:to_i)
  end

  def my_zip(*args)
    result = []
    (0..self.length-1).each do |idx|
      sub_result = [self[idx]]
      args.each { |arg| sub_result << arg[idx]}
      result << sub_result
    end
    result
  end

  def my_rotate(shift=1)
    shift = self.length+shift if shift<0
    self.drop(shift%self.length) + self.take(shift%self.length)
  end

  def my_join(delim="")
    result=""
    self.my_each { |letter| result+= "#{letter}#{delim}"}
    if result[-1]==delim
      result=result[0..-2]
    end
    result
  end

  def my_reverse
    result=[]
    self.my_each { |el| result.unshift(el) }
    result
  end
end
