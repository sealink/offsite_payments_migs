$:.push File.expand_path("../lib", __FILE__)
require 'offsite_payments_migs/version'

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'offsite_payments_migs'
  s.version      = OffsitePaymentsMigs::VERSION
  s.date         = '2018-03-27'
  s.summary      = 'MiGS integration for the activemerchant offsite_payments gem.'
  s.description  = 'This gem extends the activemerchant offsite_payments gem ' \
                   'providing integration of MiGS.'
  s.license      = 'MIT'

  s.author = 'Stefan Cooper'
  s.email = 'stefan.cooper@sealink.com.au'
  s.homepage = 'https://github.com/sealink/offsite_payments_migs'

  s.files = Dir['CHANGELOG', 'README.md', 'MIT-LICENSE', 'lib/**/*']
  s.require_path = 'lib'

  s.add_dependency('offsite_payments')
  s.add_dependency('money')
  s.add_development_dependency('rake')
  s.add_development_dependency('test-unit', '~> 3.0')
end
