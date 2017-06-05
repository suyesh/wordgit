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
  wordgit diff [VERSION1] [VERSION2]  # Displays differences between two versions
  wordgit help [COMMAND]              # Describe available commands or one specific command
  wordgit revert [VERSION]            # revert between version
  wordgit switch [VERSION]            # Switch between version
  wordgit versions                    # Displays list of version

```

#TODO: LOT OF THINGS. The most important ones in works are:
1. Difference (between versions) viewer UI
2. Merge tool

##Rubygems.org
Hosted at [Rubygems.org](https://rubygems.org/gems/s3_patron)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
