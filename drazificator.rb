#! /usr/bin/ruby

exit unless ARGV.size == 1

vo = ['a','e','i','o','u']
last = ARGV[0]
i = ARGV[0].size

i-=1 while (!vo.include?(last[i]) and i > 0) 
i-=1 while (vo.include?(last[i]) and i > 0) 

puts last[0..i]+"en "+last

