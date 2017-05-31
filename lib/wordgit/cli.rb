require 'thor'
require 'git'
require 'word-to-markdown'
require 'colorize'
require_relative './add.rb'


module Wordgit
  class Cli < Thor
    include Thor::Actions
    include Wordgit::Add
  end
end
