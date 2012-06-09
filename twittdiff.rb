require 'twitter'
unless ARGV[0]
  puts "Needs args :p"
  puts "./twittdiff username"
  exit
end

TDHOME = File.join(ENV['HOME'],".twitdiff")
unless File.exists?(TDHOME)
  Dir.mkdir(TDHOME)
end
followers = []
cursor = "-1"

while cursor != 0 do
  fl = Twitter.follower_ids(ARGV[0],{"cursor"=>cursor})
  cursor = fl.next_cursor
  followers += fl.ids
  sleep(2) # DON"T BREAK DA TWITTER
end

if File.exists?(File.join(TDHOME, ARGV[0]))
  prev = File.readlines(File.join(TDHOME, ARGV[0])).map!{|x| x.chomp!.to_i}
  new = (followers - prev)
  if new.empty?
    puts "No new followers"
  else
    puts "New followers:"
    new.each do |cool|
      puts "\t - #{Twitter.user(cool).name}"
    end
  end
  diff = (prev-followers)
  if diff.empty?
    puts "No one stop following you"
  else
    puts "Not following you anymore:"
    diff.each do |sucker|
      puts "\t - #{Twitter.user(sucker).name}"
    end
  end
else
  puts "First time twittdiff is ran, come back later"   
end
File.open(File.join(TDHOME, ARGV[0]),'w').write(followers.join("\n")+"\n")
  
