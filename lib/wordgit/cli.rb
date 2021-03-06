require 'thor'
require 'git'
require 'word-to-markdown'
require 'colorize'


module Wordgit
  class Cli < Thor
    include Thor::Actions

    no_commands do
      def create_files_and_folders(word_file, version)
        file = WordToMarkdown.new word_file
        dir_name = File.dirname word_file
        empty_directory "./.wrdgit"
        empty_directory "./.wrdgit/#{version}"
        empty_directory "./.wrdgit/#{version}/#{dir_name}"
        create_file "./.wrdgit/#{version}/#{dir_name}/#{File.basename word_file, '.docx'}.md", force: true do
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
    ## wordgit commit -m 'a message' -v [VERSION] will commit the changes with a message and a tag
    ####################################################################################################################

    desc "commit '[PATH] OR --all'", "Commits the changes to the repo."
    method_options all: false
    def commit(*path)
      init_message unless check_init
      message = ask("Message: ".colorize :blue)
      version = ask("Version: ".colorize :blue)
      if options[:all]
        Dir['**/*.docx'].reject{ |f| f['./.git'] || f['./.wrdgit'] }.each do |word_file|
          next if word_file.start_with?('~$MS')
          create_files_and_folders word_file, "v#{options[:version]}"
        end
      elsif path.count > 0
        path.each do |word_file|
          next if word_file.start_with?('~$MS')
          create_files_and_folders word_file, "v#{options[:version]}"
        end
      else
        say("You need to provide a file path or you can pass an option '--all' to track all files".colorize :blue)
      end
      begin
          g = Git.open'.'
          g.add all: true
          g.commit(message)
          g.add_tag("v#{version}")
      rescue Git::GitExecuteError
        say("Sorry but the document could not be commited, please check your input and try again.".colorize :red)
      end
    end

    ####################################################################################################################
    ## wordgit versions, will display the versions
    ####################################################################################################################

    desc "versions", "Displays list of version"
    def versions
      init_message unless check_init
      g = Git.open'.'
      g.tags.each do |tag|
        commit = g.gcommit(tag)
         say("#{tag.name.colorize :red}  #{commit.author.name.colorize :blue}     #{commit.message.colorize :green}     #{commit.date.strftime('%m-%d-%y').colorize :blue}")
      end
    end

    ####################################################################################################################
    ## wordgit diff VERSION1 VERSION2, view differences in 2 versions
    ####################################################################################################################

    desc "diff [VERSION1] [VERSION2]", "Displays differences between two versions"
    def diff(*version)
      init_message unless check_init
      g = Git.open'.'
      #TODO
    end


    ####################################################################################################################
    ## wordgit switch VERSION, view preview of version
    ####################################################################################################################

    desc "switch [VERSION]", "Switch between version"
    method_option :back, type: :boolean, default: false, aliases: "-b", desc: "Switch back to the Current version"
    def switch(*version)
      init_message unless check_init
      g = Git.open'.'
      system('git stash')
      if options[:back]
        g.checkout('master')
        say("Switched to the current version of the document".colorize :green)
      else
        g.checkout("v#{version[0]}")
        say("Switched to the v#{version[0]} of the document".colorize :green)
      end
    end

    ####################################################################################################################
    ## wordgit revert VERSION, change to a version
    ####################################################################################################################

    desc "revert [VERSION]", "revert between version"
    def revert(*version)
      init_message unless check_init
      input = ask("You are reverting to #{version[0]}. Are you sure? [Y|N]".colorize :blue)
      if input == 'Y' || input == 'y'
        g = Git.open'.'
        g.checkout('master')
        system "git reset --hard v#{version[0]}"
      end
    end
  end
end
