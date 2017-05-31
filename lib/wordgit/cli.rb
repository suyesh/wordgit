require 'thor'
require 'git'
require 'word-to-markdown'
require 'colorize'
require 'add'


module Wordgit
  class Cli < Thor
    include Thor::Actions
    include Wordgit::Add
  end
end
