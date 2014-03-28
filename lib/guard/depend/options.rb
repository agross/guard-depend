module Guard
  class Depend
    module Options
      DEFAULTS = {
          run_on_start:    false,
          output_paths:    [],
          cmd:             nil
      }

      class << self
        def with_defaults(options = {})
          _deep_merge(DEFAULTS, options)
        end

        private
        def _deep_merge(hash1, hash2)
          hash1.merge(hash2) do |key, oldval, newval|
            if oldval.instance_of?(Hash) && newval.instance_of?(Hash)
              _deep_merge(oldval, newval)
            else
              newval
            end
          end
        end
      end
    end
  end
end
