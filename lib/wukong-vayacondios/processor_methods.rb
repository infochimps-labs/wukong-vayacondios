module Wukong
  module Vayacondios

    module ProcessorInstanceMethods
      
      def vcd_topic_for_record record
        case
        when record.respond_to?(:_topic) then record._topic
        when record.is_a?(Array)         then record.first
        when record.respond_to?(:[])     then (record[:_topic] || record["_topic"])
        end
      end

      def set_vcd_topic_for record, topic
        case
        when record.respond_to?(:_topic=) then record._topic   = topic
        when record.is_a?(Array)          then record[0]       = topic
        when record.respond_to?(:[]=)     then record[:_topic] = topic
        end
      end
      
      def vcd_id_for_record record
        case
        when record.respond_to?(:_id)    then record._id
        when record.is_a?(Array)         then record[1]
        when record.respond_to?(:[])     then (record[:_id] || record["_id"])
        end
      end
      
      %w[announce get set set! delete].each do |client_method|
        define_method client_method do |*args|
          vayacondios_client.send(client_method, *args)
        end
      end

      def update_settings_every period
        update_settings
        EventMachine::Timer.new(period) do
          update_settings_every(period)
        end
      end

      def update_settings
        self.class.fields.each_pair do |name, field|
          self.send("#{field}=", value) if value = get("processor.#{label}", field)
        end
      end

      def save_settings
        self.class.fields.each_pair do |name, field|
          set("processor.#{label}", value) if value = send(field)
        end
      end

      def save_settings_every period
        save_settings
        EventMachine::Timer.new(period) do
          save_settings_every(period)
        end
      end
      
      protected

      def vayacondios_client
        Wukong::Deploy.vayacondios_client
      end

    end
  end
  
  Processor.send(:include, Vayacondios::ProcessorInstanceMethods)
end

