module Fitting
  class Configuration
    attr_accessor :rspec_json_path,
                  :webmock_json_path,
                  :fitting_report_path,
                  :prefixes,
                  :outgoing_prefixes

    def initialize(config)
      @rspec_json_path = config['rspec_json_path'] || './fitting_tests'
      @fitting_report_path = config['fitting_report_path'] || './fitting'
      @prefixes = config['prefixes'] || []
      @webmock_json_path = config['webmock_json_path'] || './outgoing_request_tests'
      @outgoing_prefixes = config['outgoing_prefixes'] || []
    end
  end
end
