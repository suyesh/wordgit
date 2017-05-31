require 'thor'
require 'git'

module Wordgit
  class Init < Thor::Group
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "Initialize Document repository"
    def setup
      empty_directory "./.wrdgit"
      Git.init
    end
  end
end
