module Wukong
  module Deploy
    def self.vayacondios_client
      return @vayacondios_client if @vayacondios_client
      require 'vayacondios-client'
      @vayacondios_client = ::Vayacondios::HttpClient.new({
          log:          Wukong::Log,
          host:         settings[:vcd_host],
          port:         settings[:vcd_port],
          organization: settings[:organization],
          dry_run:      (! settings[:vcd]),
        })
    end
  end
end

    
