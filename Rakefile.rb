#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require 'lib/pyr'

require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
require 'pathname'
include FileUtils

REV = `hg head`[/changeset: +(\d+)/, 1].to_i
PKG = VERS = Pyr::version + ".#{REV}"
RDOC_OPTS = ['-I', 'png', '--quiet', '--title', 'The Pyr RDoc Reference', '--main', 'README', '--inline-source', '-x', '(spec|skel)']
SPATH = Pathname.new(Dir.pwd)


PKG_FILES = %w(LICENSE README Rakefile.rb) +
  Dir.glob("{bin,doc,spec,lib,spec_skel}/**/*") +
  Dir.glob("ext/**/*.{h,java,c,rb,rl}")

SPEC =
  Gem::Specification.new do |s|
  s.name = 'Pyr'
  s.version = VERS[/\w+\-(.*)/, 1]
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.rdoc_options += RDOC_OPTS
  s.extra_rdoc_files = ["README", 'LICENSE']
  s.summary = "A HTML builder with access to eny old element."
  s.description = s.summary
  s.author = "Michael 'mictro' Trommer"
  s.email = '<mictro@gmail.com>'
  s.homepage = 'http://code.ackro.org/Pyr'
  s.files = PKG_FILES
end

sp=Dir['spec/*.rb'].sort.each do |f|
  FileUtils.touch(f)
end

task :spec do
  ENV['DEBUG'] = '1'
  system "spec -d -f s -r lib/pyr spec/test_pyr.rb"
end

task :gem => [:mvpkg]

task :make_gem do
  builder = Gem::Builder.new(SPEC)
  builder.build
  SPATH.dirname.entries.grep(/.gem$/).each do |gem|
    FileUtils.mv(gem, path, :verbose => true)
  end
end

task :mvpkg => :make_gem do
  path = SPATH.join('pkg')
  path.mkdir unless path.exist?
  path.dirname.entries.grep(/.gem$/).each do |gem|
    FileUtils.mv(gem, path, :verbose => true)
  end
end

task :install => :gem do
  puts `gem install pkg/pyr-#{VERS[/\w+\-(.*)/, 1]}`
end



task :specdoc => [:spechtml] do
  ENV['DEBUG'] = '1'
  sh "spec -d -f s -r lib/pyr spec/test_pyr.rb"
end

task :spechtml do
  ENV['DEBUG'] = '1'
  system("rm #{file = "/home/mit/public_html/doc/Pyr/spec.html"}")
  system("touch #{file}")
  system "spec -d -f s -r lib/pyr spec/test_pyr.rb -f h:#{file}"
end

task :rdoc do
  system('rm ~/public_html/doc/Pyr/rdoc -rf')
  system('rdoc -T rubyavailable -a -I png -S -m Pyr -o ~/public_html/doc/Pyr/rdoc')
end

task :rdia do
  system('rm ~/public_html/doc/Pyr/rdoc -rf')
  system('rdoc -T rubyavailable -a -I png -S -m Pyr -o ~/public_html/doc/Pyr/rdoc -x "(spec)" -d')
end


=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
