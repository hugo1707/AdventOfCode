result = Array.new(12) { {'1' => 0, '0' => 0} }


# 
#   TODO: Fix part one.
#

def array_to_decimal(array)
    result = 0 
    array.each_with_index do |n, index| 
        if n == 1
            result += 2 ** index
        end
    end

    return result  
end

lines = []

File.readlines(__dir__ + '/input.txt').each do |line|
    0.upto 11 do |i| 
        if line[i] == '1'
            result[i]['1'] += 1
        else
            result[i]['0'] += 1 
        end
    end

    lines.append(line.strip)
end

gamma_array = result.map { |x| x['1'] >= x['0'] ? 1 : 0 }.reverse
epsilon_array = gamma_array.map { |x| x == 1 ? 0 : 1 }

gamma_rate = array_to_decimal(gamma_array)
epsilon_rate = array_to_decimal(epsilon_array)


puts "Gamma rate: #{gamma_rate}, Epsilon rate: #{epsilon_rate}"
puts "Result: #{gamma_rate*epsilon_rate}"


puts "--- Second part ---"


#   Return a filtered array according to the specific logic.
#   
#   1) Get the "wanted"¹ value for the current bit position.
#       1.1) If both 0 and 1 are equally common, the `value_if_tie` is chosen.
#   2) Remove all elements that do not have that value in the current bit position.
#   3) Return new array.
#   4) Do this until there is only one element left.
#
#   (This function does steps from 1 to 3.)
#   
#   ¹: This "wanted" property can be either "MOST_COMMON" or "LEAST_COMMON"
#
def filter_lines(lines, bit_position, wanted, value_if_tie) 
    if wanted != "MOST_COMMON" && wanted != "LEAST_COMMON"  
        throw "Bad input (wanted: #{wanted})"
    end
    
    if lines.length == 1 
        return lines 
    end

    # Step 1
    count_0 = 0
    count_1 = 0

    lines_with_0 = []
    lines_with_1 = []

    lines.each_with_index do |line, index| 
        if line[bit_position] == '0' 
            count_0 += 1
            
            # This should make it easier to remove them on step 2.
            lines_with_0.push(index)
        elsif line[bit_position] == '1'
            count_1 += 1
            
            lines_with_1.push(index)
        end
    end 

    wanted_value = nil
    if count_0 > count_1 
        wanted_value = (wanted == "MOST_COMMON") ? 0 : 1;
    elsif count_0 < count_1 
        wanted_value = (wanted == "MOST_COMMON") ? 1 : 0;
    else # count_0 == count_1 (Step 1.1)
        wanted_value = value_if_tie
    end 

    # Step 2
    if wanted_value == 0
        # This removes all elements whose index is included in `lines_with_1`
        return lines.reject.with_index { |_line, i| lines_with_1.include? i }
    elsif wanted_value == 1
        return lines.reject.with_index { |_line, i| lines_with_0.include? i }
    end

    throw "Bad input"
end


oxygen_lines = lines.map(&:clone)

bit_position = 0
until oxygen_lines.length == 1
    oxygen_lines = filter_lines(oxygen_lines, bit_position, "MOST_COMMON", 1)
    bit_position += 1
end

oxygen_lines_num = array_to_decimal(oxygen_lines[0].reverse.split("").map(&:to_i))

co2_scrubber_rating = lines.map(&:clone)

bit_position = 0
until co2_scrubber_rating.length == 1
    co2_scrubber_rating = filter_lines(co2_scrubber_rating, bit_position, "LEAST_COMMON", 0)
    bit_position += 1
end

co2_scrubber_rating_num = array_to_decimal(co2_scrubber_rating[0].reverse.split("").map(&:to_i))


puts "Oxygen generator rating: #{oxygen_lines_num}, CO² scrubber rating: #{co2_scrubber_rating_num}, Life support: #{oxygen_lines_num*co2_scrubber_rating_num}"