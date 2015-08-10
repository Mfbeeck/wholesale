arr = [1, 2, 3]

# puts shuffling(arr)

#below shuffles that array 5 times
# 5.times do
# 	arr = arr.shuffle
# end
# puts arr


@last_three_digits_of_current_time = (Time.now.to_i.to_s.split('')[-3].to_i + Time.now.to_i.to_s.split('')[-2].to_i + Time.now.to_i.to_s.split('')[-1].to_i)

@last_three_digits_of_current_time.times do
	arr = arr.shuffle
end
 
 @winning_consumer_order = arr.sample

 puts @winning_consumer_order



# puts arr


# def shuf(n=7) 

# n.times { shuffling([1,2,3,4,5]) }

# end

# puts shuf(8)

