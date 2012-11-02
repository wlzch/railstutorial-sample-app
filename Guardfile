# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'active_support/core_ext'

guard 'rspec', :version => 2, :all_after_pass => false do
  watch (%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
      ["spec/routing/#{m[1]}_routing_spec.rb",
       "spec/#{m[2]}s/#{m[2]}_spec.rb",
       "spec/acceptance/#{m[1]}_spec.rb",
       (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
                         "spec/requests/#{m[1]}_pages_spec.rb")]
  end
  watch (%r{^app/views/(.+)/}) do |m|
      (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
                        "spec/requests/#{m[1]}_pages_spec.rb")
  end
  watch (%r{^app/models/(.+)\.rb$}) { |m| "spec/models/#{m[1]}_spec.rb" }
  watch (%r{^spec/.+(_spec|Spec)\.rb$})
  watch ("config/routes.rb") { "spec/" }
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch ('config/application.rb')
  watch ('config/environment.rb')
  watch (%r{^config/environments/.+\.rb$})
  watch (%r{^config/initializers/.+\.rb$})
  watch ('Gemfile')
  watch ('Gemfile.lock')
  watch ('spec/factories.rb')
  watch ('spec/spec_helper.rb') { :rspec }
  watch ('test/test_helper.rb') { :test_unit }
  watch (%r{^spec/support/.+\.rb$})
end
