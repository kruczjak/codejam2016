require 'prime'

class TooLongException < Exception; end
class NotPrimeException < Exception; end

MAX_S = 2 #s

class Integer
  def is_prime?
    t1 = Time.now.to_i
    prime = true
    for r in 2..Math.sqrt(self).to_i
      if (self % r == 0)
        prime = false
        break
      end
      fail TooLongException if Time.now.to_i - t1 > MAX_S
    end
    return prime
  end
end

class SpecialEnumerator
  include Enumerable

  def initialize(length)
    @length = length
  end

  # a bit faster permutations using Array#permutation
  def each(&block)
    current_length = 1

    while true do
      to_p = (Array.new(current_length, 0) + Array.new(current_length, 1))
               .permutation(current_length)

      to_p.each do |arr|
        joined = arr.join
        block.call "#{'0'*(@length-current_length)}#{joined}"
        block.call "#{joined}#{'0'*(@length-current_length)}"
        block.call "#{joined}#{'1'*(@length-current_length)}"
        block.call "#{'1'*(@length-current_length)}#{joined}"

        block.call "#{'1'*((@length-current_length)/2)}#{joined}#{'1'*((@length-current_length)/2)}#{'1'*((@length-current_length) % 2)}"
        block.call "#{'1'*((@length-current_length)/2)}#{joined}#{'1'*((@length-current_length)/2)}#{'0'*((@length-current_length) % 2)}"
        block.call "#{'0'*((@length-current_length)/2)}#{joined}#{'1'*((@length-current_length)/2)}#{'1'*((@length-current_length) % 2)}"
        block.call "#{'0'*((@length-current_length)/2)}#{joined}#{'1'*((@length-current_length)/2)}#{'0'*((@length-current_length) % 2)}"

        block.call "#{'1'*((@length-current_length)/2)}#{joined}#{'0'*((@length-current_length)/2)}#{'1'*((@length-current_length) % 2)}"
        block.call "#{'1'*((@length-current_length)/2)}#{joined}#{'0'*((@length-current_length)/2)}#{'0'*((@length-current_length) % 2)}"
        block.call "#{'0'*((@length-current_length)/2)}#{joined}#{'0'*((@length-current_length)/2)}#{'1'*((@length-current_length) % 2)}"
        block.call "#{'0'*((@length-current_length)/2)}#{joined}#{'0'*((@length-current_length)/2)}#{'0'*((@length-current_length) % 2)}"
      end

      current_length += 1

      break if current_length > @length
    end
  end
end

def check_string_number(string_number)
  puts 'testing prime'
  arr = []

  9.times do |time|
    number = Integer(string_number, time + 2)
    puts "testing: #{time} - #{string_number}"
    fail NotPrimeException if number.is_prime?
    arr << number
  end

  return arr
end

####################################

input = File.readlines('input_c')
out = File.open('output_c2', 'w')
input.shift

out.puts('Case #1:')
N, J = input.first.split(' ').map { |str| Integer(str, 10) }
GEN_N = N - 2
i = 0

was = []
SpecialEnumerator.new(GEN_N).each do |elem|
  next if was.include?(elem)
  was << elem

  string_number = "1#{elem}1"
  begin
    numbers = check_string_number(string_number)
  rescue NotPrimeException, TooLongException
    puts "failure with #{string_number}"
    next
  end

  puts "numbers: #{numbers}"

  numbers.map! do |num|
    (2..num-1).find { |divisor| num % divisor == 0 }
  end

  out.puts("#{string_number} #{numbers.join(' ')}")
  puts "!!!!! <#{i}> passed"
  i += 1
  break if i == J #done
end
