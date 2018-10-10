#!/usr/bin/ruby

#make a table using an array of objects and same-sized array
#of their frequencies (integers)
def make_table(datapoints, freqs)
	#find num, min, max, range, relative & cumulative frequencies
	total_freq = 0
	freqs.each do |v|
		total_freq += v
	end

	num = datapoints.length
	min = datapoints.min
	max = datapoints.max
	range = (datapoints[0].class == String) ? "..." :  max - min
	#cum. and rel. frequencies
	relative = []
	cumulative = []
	freqs.each do |v|
		relative.push((v.to_f/total_freq).round(2))
		if(cumulative.length > 0)
			cumulative.push(cumulative[cumulative.length-1] + v)
		else
			cumulative.push(v)		
		end
	end

	#make table
	puts "table:"
	puts "data | frequency | relative | cumulative"
	datapoints.length.times do |x|
		puts sprintf("%4s:  %9d   %8.2f   %10d", datapoints[x].to_s, freqs[x],
			relative[x], cumulative[x])
	end

	puts "________________________________________"
	puts "total:"
	puts sprintf("%4d   %9d", num, total_freq)
	puts sprintf("min: #{min} max: #{max} range: #{range}")
end
#take integer frequency data and turn into classes
#of arbitrary size
def data_to_classes(datapoints, freqs)
	if !(datapoints[0].is_a? Integer)
		STDERR.puts "can't make classes out of non-integers"
		return
	end
	puts "how many classes?"
	class_num = gets.chomp.to_i

	min = datapoints.min
	max = datapoints.max

	class_width = ((max - min).to_f / class_num).ceil
	puts("class_width: #{class_width}")

	#create classes and class_frequencies
	classes = Array.new(class_num, 0)
	class_frequencies = Array.new(class_num, 0)

	index = 0 #index in original arrays
	class_num.times do |c|
		current_class_min = min + (class_width * c)
		current_class_max = current_class_min + class_width - 1
		#create class as string
		classes[c] = sprintf("%d-%d", current_class_min, current_class_max)
		#find its freq
		while datapoints[index] != nil && datapoints[index] <= current_class_max
			class_frequencies[c] += freqs[index]
			index += 1
		end
	end
	return classes, class_frequencies
end	
#get sample data, return [datapoints, frequencies]
def get_data
	#get data into hash: default val (frequency) is 0
	frequencies = Hash.new(0)

	puts "enter all data, then end with a blank"
	puts "\"-\" to cancel last addition"
	puts "alternatively, enter [datapoint]/[frequency] to manually set"
	ans = nil
	last_ans = nil

	while ans != "" do
		ans = gets.chomp
		if ans == ""
			break
		elsif ans.include? "/"
			answers = ans.split("/")
			frequencies[answers[0].to_i] = answers[1].to_i
		elsif ans == "-"
			frequencies[last_ans.to_i] -= 1
		else
			frequencies[ans.to_i] += 1
		end
		last_ans = ans
	end

	#turn hash into sorted array (by datapoint)
	#like [[datapoint, freq], [[datapoint, freq]]
	#then separate into arrays of datapoints and frequencies to graph
	datapoints = []
	freqs = []
	(frequencies.sort_by { |k, v| k }).each do |k, v|
		datapoints.push(k)
		freqs.push(v)
	end

	return datapoints, freqs
end

datapoints, freqs = get_data()
make_table(datapoints, freqs)

#convert to classes & graph
puts "sort into classes? [y/N]"

if gets.chomp == "y"
	datapoints, freqs = data_to_classes(datapoints, freqs)
	make_table(datapoints, freqs)
end

exit 0
