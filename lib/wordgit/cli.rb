require 'thor'
require 'git'
require 'word-to-markdown'
require 'colorize'


module Wordgit
  class Cli < Thor
    include Thor::Actions

    no_commands do
      def create_files_and_folders(word_file)
        file = WordToMarkdown.new word_file
        dir_name = File.dirname word_file
        empty_directory "./.wrdgit/#{dir_name}"
        create_file "./.wrdgit/#{dir_name}/#{File.basename word_file, '.docx'}.md", force: true do
          file.to_s
        end
      end

      def check_init
        File.directory?('./.git') && File.directory?('./.wrdgit')
      end

      def init_message
        input = ask("No wordgit repo was found. Do you want to initialize it? [Y|N]".colorize :blue)
        input == 'y' || input == 'Y' ? Wordgit::Init.start : abort("Exiting Wordgit since no repo was found!".colorize :red)
      end
    end


    ####################################################################################################################
    ## wordgit add [parameters] or option --all will add single or multiple files to the git repo to track
    ####################################################################################################################

    desc "add PATH","Add files to track. Or just say '--all' instead of supplying PATH to add all files"
    method_options all: false
    def add(*path)
      init_message unless check_init
      if options[:all]
        Dir['**/*.docx'].reject{ |f| f['./.git'] || f['./.wrdgit'] }.each {|word_file| create_files_and_folders word_file }
      elsif path.count > 0
        path.each {|word_file| create_files_and_folders word_file }
      else
        say("You need to provide a file path or you can pass an option '--all' to track all files".colorize :blue)
      end
      g = Git.open'.'
      g.add all: true
    end


    ####################################################################################################################
    ## wordgit commit -m 'a message' will commit the changes with a message
    ####################################################################################################################

    desc "commit", "Commits the changes to the repo. -m followed by message as string 'your message' is required"
    method_option :message, aliases: "-m", desc: "Add message to the commit.",required: true
    def commit
      init_message unless check_init
      g = Git.open'.'
      g.commit(options[:message])
    end

    ####################################################################################################################
    ## wordgit log, will display the logs of commits
    ####################################################################################################################

    desc "log", "Displays history of commits"
    def log
      init_message unless check_init
      g = Git.open'.'
      g.log.each do |log|
        puts g.show(log)
      end
    end

  end
end
