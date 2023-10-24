# Take Home Code Challenge

## Working Out Loud

### Boilerplate

Because boiler platting is boring, I've chosen a boilerplate: https://github.com/postmodern/ruby-cli-boilerplate
It is a boilerplate Ruby CLI app that can be used to implement a basic zero-dependency CLI for other Ruby libraries.

#### Features

* Zero-dependencies, making it ideal for adding a CLI to small libraries.
* Correctly handles `Ctrl^C` and broken pipe exceptions.
* Catches any other exceptions and prints a bug report.
* Defines the CLI as a class, making it easy to test.
* Comes with boilerplate RSpec tests.

### Create a `CompanyReport` class

Which generates report string.

### Create a `Main` class to glue together the pieces

- Add `models.rb` with structs for users and companies
- Add `main.rb` where I glue things together
- Changed `CompanyReport` to work with structs
- Make CLI executable working

### Made some adjustments to meet all requirements and match `example_output.txt`

Here is a help message when you don't provide files:

```
$ bin/takehome                                                                       
bin/takehome: File `` does not exist! Please provide the correct file.

usage: bin/takehome [options] ARG ...

Options:
    -c, --companies FILE             Path to the companies JSON file (required)
    -u, --users FILE                 Path to the users JSON file (required)
    -V, --version                    Print the version
    -h, --help                       Print the help output
```

Here is me generating new report and comparing it to example:

```
$ bin/takehome -c companies.json -u users.json > output.txt                          
$ diff example_output.txt output.txt                                                 
89a90
> 
```

## Installation

I've used [ASDF](https://github.com/asdf-vm/asdf-ruby). So if you have ASDF installed and you enter a directory ASDF will use or install proper version. Then `bundle install` and you are good to go.

## Code challenge

You have a JSON file of users and companies. Create code in Ruby that process these files and creates an `output.txt` file.

### Criteria for the output file.

Any user that belongs to a company in the companies file and is active needs to get a token top up of the specified amount in the companies top up field.

If the users company email status is true indicate in the output that the user was sent an email ( don't actually send any emails). However, if the user has an email status of false, don't send the email regardless of the company's email status.

Companies should be ordered by company id. Users should be ordered alphabetically by last name.

### Important points

- There could be bad data
- The code should be run-able in a command line
- Code needs to be written in Ruby
- Code needs to be clone-able from GitHub
- Code file should be named challenge.rb

### Assessment Criteria

- Functionality
- Error Handling
- Re-usability
- Style
- Adherence to convention
- Documentation
- Communication
