module Wukong
  class Processor

    class Lookup < Processor
      field :input, Whatever, doc: "Fixed request to return"
      field :topic, String,   doc: "Default topic for records"
      def process record
        if input
          yield get(input)
        else
          request = perform_action(record)
          yield get( request.is_a?(Hash) ? request : *request)
        end
      end

      def perform_action record
        [ topic || vcd_topic_for_record(record), vcd_id_for_record(record)]
      end
      register
    end

    class Announce < Processor

      field :topic, String,   doc: "Default topic for records"

      def process record
        request = perform_action(record)
        announce( request.is_a?(Hash) ? request : *request)
      end

      def perform_action record
        [topic || vcd_topic_for_record(record), record]
      end

      
      register :announce
    end
    
    class Stash < Processor

      field :topic,   String,   doc: "Default topic for records"
      field :clobber, :boolean, default: false, doc: "When writing configs, whether to overwrite.  Default behavior is to merge."

      def process record
        request = perform_action(record)
        if clobber
          set!( request.is_a?(Hash) ? request : *request)
        else
          set( request.is_a?(Hash) ? request : *request)
        end
      end

      def perform_action record
        [topic || vcd_topic_for_record(record), vcd_id_for_record(record), record]
      end

      register :stash
    end

    class StashClobber < Stash
      def clobber
        true
      end
      register :stash!
    end
    
  end
end

