# frozen_string_literal: true

require 'optparse'
require_relative './main'

# The CLI class to work with user input.
class CLI
  PROGRAM_NAME = 'bin/takehome'

  # The CLI version
  VERSION = '0.1.0'

  # The URL to report bugs to.
  BUG_REPORT_URL = 'https://github.com/kukula/takehome/issues/new'

  # Initializes the CLI.
  #
  def initialize
    @option_parser = option_parser
  end

  #
  # Initializes and runs the CLI.
  #
  # @param [Array<String>] argv
  #   Command-line arguments.
  #
  # @return [Integer]
  #   The exit status of the CLI.
  #
  def self.run(argv = ARGV)
    new.run(argv)
  rescue Interrupt
    # https://tldp.org/LDP/abs/html/exitcodes.html
    130
  rescue Errno::EPIPE
    # STDOUT pipe broken
    0
  end

  #
  # Runs the CLI.
  #
  # @param [Array<String>] argv
  #   Command-line arguments.
  #
  # @return [Integer]
  #   The return status code.
  #
  def run(argv = ARGV)
    args = @option_parser.parse(argv)
    validate_files!
    generate_report(args)
    0
  rescue OptionParser::InvalidOption => e
    print_error(e)
    -1
  rescue RuntimeError => e
    print_backtrace(e)
    -1
  end

  # The option parser.
  #
  # @return [OptionParser]
  #
  def option_parser
    @option_parser ||= OptionParser.new do |opts|
      opts.banner = "usage: #{PROGRAM_NAME} [options] ARG ..."

      opts.separator ''
      opts.separator 'Options:'

      opts.on('-c', '--companies FILE', 'Path to the companies JSON file (required)') do |file|
        @companies_file = file
      end

      opts.on('-u', '--users FILE', 'Path to the users JSON file (required)') do |file|
        @users_file = file
      end

      opts.on('-V', '--version', 'Print the version') do
        puts "#{PROGRAM_NAME} #{VERSION}"
        exit
      end

      opts.on('-h', '--help', 'Print the help output') do
        puts opts
        exit
      end
    end
  end

  private

  attr_reader :companies_file, :users_file

  def generate_report(_args)
    puts Main.new(companies_file:, users_file:).run
  end

  def validate_files!
    [companies_file, users_file].each do |file|
      raise "File `#{file}` does not exist! Please provide the correct file." unless file && File.exist?(file)
    end
  rescue RuntimeError => e
    print_error(e)
    puts
    puts option_parser.help
    exit
  end

  # Prints an error message to stderr.
  #
  # @param [String] error
  #   The error message.
  #
  def print_error(error)
    warn "#{PROGRAM_NAME}: #{error}"
  end

  #
  # Prints a backtrace to stderr.
  #
  # @param [Exception] exception
  #   The exception.
  #
  def print_backtrace(exception)
    warn <<~ERR
      Please report the following text to: #{BUG_REPORT_URL}"

      ```
      #{exception.full_message}
      ```
    ERR
  end
end
