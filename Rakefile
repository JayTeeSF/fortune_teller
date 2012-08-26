require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("fortune_teller.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["fortune_teller.gemspec"] do
  system "gem build fortune_teller.gemspec"
  system "gem install fortune_teller-#{FortuneTeller::VERSION}.gem"
end
