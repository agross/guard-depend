require 'rake'

module Guard
  class Depend
    class Runner
      def run(cmd)
        return unless cmd

        cmd = [cmd].flatten
        command = cmd.join(' ')

        begin
          UI.info("Running '#{command}'")
          Notifier.notify(command, title: 'Running', image: :success)

          sh(*cmd)

          Notifier.notify("#{command} succeeded", title: 'Success', image: :success)
        rescue Exception => e
          UI.error("Failed to run '#{command}'. Exception was: #{e.class}: #{e.message}")
          UI.debug(e.backtrace.join("\n"))

          Notifier.notify("#{command} failed with #{e}", title: 'Failed', image: :failed)
        end
      end

      private
      include FileUtils
    end
  end
end
