#! /usr/bin/ruby

vo = ['a','e','i', 'o','u' ]
last = ARGV[0]
i = last.size
while (!vo.include?(last[i]) and i > 0)
  i-=1
end
while (vo.include?(last[i]) and i > 0) 
  i-=1;
end
puts last[0..i]+"en "+last

