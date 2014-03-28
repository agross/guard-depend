require 'guard'
require 'guard/plugin'

module Guard
  class Depend < Plugin
    require 'guard/depend/detect'
    require 'guard/depend/runner'

    DEFAULTS = {
      run_on_start: false,
      output_paths: [],
      cmd: nil
    }

    attr_reader :options, :runner, :detect

    def initialize(options = {})
      super
      @options = DEFAULTS.merge(options)
      @runner = Runner.new
      @detect = Detect.new(@options[:output_paths])
    end

    def start
      UI.info "#{self.class} is running"
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
      @runner.run(@options[:cmd]) if detect.out_of_date?(paths)
    end
  end
end
