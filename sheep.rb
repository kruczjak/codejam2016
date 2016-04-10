GC.disable
class Fixnum
  def digits(base: 10)
    quotient, remainder = divmod(base)
    quotient == 0 ? [remainder] : [*quotient.digits(base: base), remainder]
  end
end

file = File.readlines('input')
out = File.open('out', 'w')

t = Integer(file.shift, 10)

t.times do |test_number_i|
    arr = Array.new(10, 0)
    n = Integer(file[test_number_i], 10)
    i = 1

    while true do
      if n == 0
        out.puts("Case ##{test_number_i+1}: INSOMNIA")
        break
      end

      test_number = n * i

      test_number.digits.each { |digit| arr[digit] += 1 }

      if arr.all? { |elem| elem > 0 }
        out.puts("Case ##{test_number_i+1}: #{test_number}")
        break
      end

      i += 1
    end
end
