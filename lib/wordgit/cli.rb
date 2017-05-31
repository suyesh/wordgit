require 'thor'
require 'git'
require 'word-to-markdown'
require 'colorize'


module Wordgit
  class Cli < Thor
    include Thor::Actions

    no_commands do
      def create_files_and_folders(word_file)
        file = WordToMarkdown.new(word_file)
        dir_name = File.dirname(word_file)
        empty_directory "./.wrdgit/#{dir_name}"
        create_file "./.wrdgit/#{dir_name}/#{File.basename(word_file, '.docx')}.md", force: true do
          file.to_s
        end
      end
    end


    ####################################################################################################################
    ## wordgit add [parameters] or option --all will add single or multiple files to the git repo to track
    ####################################################################################################################
    desc "Add PATH","Add files to track. Pass '--all' to add all files"
    method_options :all => false
    def add(*path)
      if options[:all]
        Dir['**/*.docx'].reject{ |f| f['./.git'] || f['./.wrdgit'] }.each do |word_file|
          create_files_and_folders word_file
        end
      elsif path.count > 0
        path.each do |word_file|
          create_files_and_folders word_file
        end
      else
        puts "You need to provide a file path or you can pass an option '--all' to track all files".colorize(:blue)
      end
      g = Git.open('.')
      g.add(:all=>true)
    end


  end
end
