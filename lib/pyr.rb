#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require 'delegate'

$:.unshift(File.dirname(__FILE__))
%w'tidy outp build eles ele'.each do |l|
  require "pyr/" + l
end

# :include:../README.rdoc
module Pyr

  attr_accessor :build_block

  VERSION = %w(0 1)
  
  def version
    "Pyr-#{VERSION.join('.')}"
  end
  module_function :version
  
  def self.build(&blk)
    pyr = Pyr::Elements.new.extend(Builder).build(&blk)
    pyr.close_clean
    pyr
  end

end




=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
