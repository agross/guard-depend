module Guard
  class Depend
    class Detect
      attr_reader :output_paths

      def initialize(output_paths = nil)
        @output_paths = output_paths
      end

      def out_of_date?(paths = [])
        paths = paths || []
        return false if paths.empty?

        outdated = check(paths, output)
        UI.debug("#{output.join(', ')} is not outdated with regard to #{paths.join(', ')}") unless outdated

        outdated
      end

      private
      def output
        paths = output_paths
        paths = output_paths.call if output_paths.respond_to?(:call)

        [paths].flatten.reject(&:nil?)
      end

      def check(input, output)
        input = input.max_by { |f| input_mtime(f) }
        output = output.min_by { |f| output_mtime(f) }

        input_mtime = input_mtime(input)
        output_mtime = output_mtime(output)

        UI.debug("Newest input file:  #{input_mtime} #{input}")
        UI.debug("Oldest output file: #{output_mtime} #{output}")

        return input_mtime > output_mtime
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
end
