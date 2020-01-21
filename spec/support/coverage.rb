begin
  require 'codacy-coverage'
  require 'simplecov'

  Codacy::Reporter.start

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    Codacy::Formatter
  ])

  SimpleCov.start do
    track_files '/lib/**/*.rb'
    add_filter '/spec/'
    add_filter '/lib/rails/**'
  end
rescue LoadError
  puts 'Not reporting coverage...'
end
