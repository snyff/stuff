def rand(i)
  ((Float(i*0x10001+55555555)*3+Float(i*0x10000001))%0x3FFFFFFF)/0x3FFFFFFF
end

puts rand(1)
