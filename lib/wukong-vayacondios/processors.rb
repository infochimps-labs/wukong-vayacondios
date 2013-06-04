module Wukong
  class Processor

    class Lookup < Processor
      field :topic, String, doc: "Default topic for records"
      def process record
        yield get(*perform_action(record))
      end

      def perform_action record
        [ topic || vcd_topic_for_record(record), vcd_id_for_record(record)]
      end
      register
    end

    class Announce < Processor

      field :topic, String,   doc: "Default topic for records"

      def process record
        announce(*perform_action(record))
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
        if clobber
          set!(*perform_action(record))
        else
          set(*perform_action(record))
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

