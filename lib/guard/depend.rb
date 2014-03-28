require 'guard'
require 'guard/plugin'

module Guard
  class Depend < Plugin
    require 'guard/depend/runner'

    DEFAULTS = {
      run_on_start: false,
      output_paths: [],
      cmd: nil
    }

    def initialize(options = {})
      super
      @options = options.merge(DEFAULTS)
      @runner = Runner.new
    end

    def start
      UI.info 'Guard::Depend is running'
      run_all if @options[:run_on_start]
    end

    def stop
    end

    def reload
    end

    def run_all
      @runner.run(@options[:cmd])
    end

    def run_on_changes(paths = [])
      run_if_outdated(paths)
    end

    private
    def run_if_outdated(paths = [])
      return false if paths.empty?

      outdated = out_of_date?(paths, @options[:output_paths])
      unless outdated
        UI.debug("Output is not outdated with regard to #{paths}")
        return
      end

      @runner.run(@options[:cmd])
    end

    def out_of_date?(input, output)
      output = output.call if output.respond_to?(:call)

      return true if input.nil? || input.empty? || output.nil? || output.empty?

      input = input.max_by {|f| input_mtime(f) }
      output = output.min_by {|f| output_mtime(f) }

      input_time = input_mtime(input)
      output_time = output_mtime(output)

      UI.debug("Newest input file:  #{input_time} #{input}")
      UI.debug("Oldest output file: #{output_time} #{output}")

      return input_time > output_time
    end

    def input_mtime(file)
      return Time.new(9999, 12, 31) unless File.readable?(file)
      File.mtime(file)
    end

    def output_mtime(file)
      return Time.new(0, 1, 1) unless File.readable?(file)
      File.mtime(file)
    end
  end
end
