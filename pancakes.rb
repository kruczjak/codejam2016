HAPPY = '+'
BLANK = '-'

def invert(char)
  char == HAPPY ? BLANK : HAPPY
end

def flip_pancakes(string, end_i)
  string.chars.each_with_index.map do |char,i|
    i < end_i ? invert(char) : char
  end.join
end

input = File.readlines('input_p')
out = File.open('output_p', 'w')
T = Integer(input.shift, 10)

T.times do |i|
  k = 0
  pancakes = input[i].chomp
  size = pancakes.size

  size.times do |iteration|
    next if pancakes[size-iteration-1] == HAPPY
    fail 'sth wrong...' if pancakes[size-iteration-1] != BLANK

    pancakes = flip_pancakes(pancakes, size-iteration-1)
    k += 1
  end

  out.puts("Case ##{i+1}: #{k}")
end
