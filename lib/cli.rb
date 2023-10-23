# frozen_string_literal: true

require 'optparse'

# The CLI class to work with user input.
class CLI
  PROGRAM_NAME = 'takehome'

  # The CLI version
  VERSION = '0.1.0'

  # The URL to report bugs to.
  BUG_REPORT_URL = 'https://github.com/kukula/takehome/issues/new'

  # The CLI's option parser.
  #
  # @return [OptionParser]
  attr_reader :option_parser

  #
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
    generate_report(args)
  rescue OptionParser::InvalidOption => e
    print_error(e)
    -1
  rescue RuntimeError => e
    print_backtrace(e)
    -1
  end

  def generate_report(args)
    puts args
  end

  #
  # The option parser.
  #
  # @return [OptionParser]
  #
  def option_parser
    OptionParser.new do |opts|
      opts.banner = "usage: #{PROGRAM_NAME} [options] ARG ..."

      opts.separator ''
      opts.separator 'Options:'

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

  #
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
