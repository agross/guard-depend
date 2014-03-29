# Guard::Depend

[![Gem Version](https://badge.fury.io/rb/guard-depend.png)](http://badge.fury.io/rb/guard-depend) [![Dependency Status](https://gemnasium.com/agross/guard-depend.png)](https://gemnasium.com/agross/guard-depend) [![Code Climate](https://codeclimate.com/github/agross/guard-depend.png)](https://codeclimate.com/github/agross/guard-depend)

guard-depend is useful for projects that produce build output like binaries. guard-depend will only run the command you specify if the build output does not exist or is not up to date with regard to the watched files.

* Tested against Ruby 2.0.0 and 2.1.0

## Installation

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Add this line to your application's `Gemfile`:

```ruby
group :development do
  gem 'guard-depend'
end
```

And then execute:

```bash
$ bundle install guard-depend
```

Or install manually:

```bash
$ gem install guard-depend
```

Add guard definition to your `Guardfile` by running this command:

```bash
$ guard init depend
```

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme)

## Guardfile

guard-depend can be adapted to all kind of projects.

### .NET project

```ruby
guard :depend,
  # The path to the output generated by cmd. This can be a single value, an array or a callable returning any of both.
  output_paths: Proc.new { Dir['build/bin/*.dll'] },
  # The command to run if the output is outdated or does not exist.
  cmd: %w(bundle exec rake compile),
  # Whether to run at startup.
  run_on_start: false do
    watch(%r{^source/.*\.cs$}i)
end
```

Please read [Guard doc](https://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Development

* Source hosted at [GitHub](https://github.com/agross/guard-depend)
* Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/agross/guard-depend/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change you make.

## Contributing

1. Fork it (http://github.com/agross/guard-depend/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
