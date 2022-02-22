module Fitting
  class Configuration
    attr_accessor :fitting_report_path,
                  :prefixes,
                  :outgoing_prefixes

    def initialize(config)
      @fitting_report_path = config['fitting_report_path'] || './fitting'
      @prefixes = config['prefixes'] || []
      @outgoing_prefixes = config['outgoing_prefixes'] || []
    end
  end
end
