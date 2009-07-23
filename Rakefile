%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
$:.push File.dirname(__FILE__) + '/lib'
require 'link_header'
require 'hoe'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'link_header' do
  developer('Mike Burrows', 'mjb@asplake.co.uk')
  self.version = LinkHeader::VERSION
  self.readme_file          = "README.rdoc"
  self.changes              = paragraphs_of("History.txt", 0..1).join("\n\n")
  self.rubyforge_name       = 'link-header'
  self.url = 'http://github.com/asplake/link_header/tree'
  self.extra_deps         = [
  ]
  self.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
  self.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (rubyforge_name == name) ? rubyforge_name : "\#{rubyforge_name}/\#{name}"
  self.remote_rdoc_dir = File.join(path.gsub(/^#{rubyforge_name}\/?/,''), 'rdoc')
  self.rsync_args = '-av --delete --ignore-errors'
end

task :info do
  puts "version=#{LinkHeader::VERSION}"
  [:description, :summary, :changes, :author, :url].each do |attr|
    puts "#{attr}=#{$hoe.send(attr)}\n"
  end
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

