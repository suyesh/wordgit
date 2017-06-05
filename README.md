# Wordgit - Word Document Versioning tool

Wordgit lets you version word document from terminal.


## Setup
Make sure [Ruby](https://www.ruby-lang.org/en/documentation/installation/) is installed.
Make sure [Libre Office](https://www.libreoffice.org/) is installed

Execute:
```
    $ gem install wordgit
```

## Usage

```shell
#List of Commands:
$ wordgit -h  

Commands:
  wordgit commit '[PATH] OR --all'    # Commits the changes to the repo.
  wordgit diff [VERSION1] [VERSION2]  # Displays differences between two versions (WORK IN PROGRESS)
  wordgit help [COMMAND]              # Describe available commands or one specific command
  wordgit revert [VERSION]            # revert between version
  wordgit switch [VERSION]            # Switch between version
  wordgit versions                    # Displays list of version

```

#STEP 1 (initialize)

```ruby
$ wordgit init #Initialize wordgit in folder with word documents you want to track
```

#STEP 2 (commit)

```ruby
#This will start tracking the document. You must provide a message and version in the prompt.

$ wordgit commit ./my_word_document.docx #you can provide individual file

#OR

$wordgit commit --all #entire folder
```

```shell
$ wordgit versions #displays all the versions
```

```shell
$ wordgit switch [VERSION NUMBER] #Switches to particular version
```

```shell
$ wordgit revert [VERSION NUMBER] #reverts the changes to particular version
```

```shell
$ wordgit diff [VERSION1] [VERSION2] #opens up GUI to display differences in versions
```

#TODO: LOT OF THINGS. The most important ones in works are:
1. Difference (between versions) viewer UI
2. Merge tool

##Rubygems.org
Hosted at [Rubygems.org](https://rubygems.org/gems/s3_patron)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
