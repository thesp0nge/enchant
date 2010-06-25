begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "enchant"
    gemspec.summary = "Your magical web application fuzzer"
    gemspec.description = "Enchant is tool aimed to discover web application directory and pages by fuzzing the requests using a dictionary approach"
    gemspec.email = "paolo@armoredcode.com"
    gemspec.homepage = "http://github.com/thesp0nge/enchant"
    gemspec.authors = ["Paolo Perego"]
    gemspec.add_dependency('ruby-progressbar')
    gemspec.add_dependency('rainbow')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end