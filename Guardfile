case RbConfig::CONFIG['target_os']
when /windows|bccwin|cygwin|djgpp|mingw|mswin|wince/i
  notification :gntp, :host => 'localhost'
when /linux/i
  notification :notifysend
when /mac|darwin/i
  notification :growl
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec',
  :all_on_start => true,
  :all_after_pass => true,
  :notification => true,
  :cmd => 'bundle exec rspec' do
    watch('.rspec')              { 'spec' }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})    { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { 'spec' }
end
