require 'wukong-deploy'
require 'vayacondios-client'

module Wukong
  
  # Wukong::Vayacondios adds code and options to Wukong Processors to
  # let them read/write events & configuration to/from Vayacondios.
  module Vayacondios
    include Plugin

    # Configure the given `settings` to add Vayacondios options
    #
    # @param [Configliere::Param] settings
    # @return [Configliere::Param] the newly configured settings
    def self.configure settings, program
      settings.define(:vcd,             :description => "Interact with Vayacondios server", type: :boolean, default: false)
      settings.define(:vcd_host,        :description => "Host for Vayacondios server", default: 'localhost')
      settings.define(:vcd_port,        :description => "Port for Vayacondios server", type: Integer, default: 9000)
      settings.define(:organization,    :description => "Vayacondios organization")
    end

    # Boot Wukong::Vayacondios with the given `settings` in the given `dir`.
    #
    # @param [Configliere::Param] settings
    # @param [String] root
    def self.boot settings, root
    end

  end
end

require_relative('wukong-vayacondios/processor_methods')
require_relative('wukong-vayacondios/processors')
require_relative('wukong-vayacondios/deploy_pack')
