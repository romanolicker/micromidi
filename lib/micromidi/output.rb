#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Output
      
      include MIDIMessage
      
      def initialize(outs)
        @channel = Default[:channel]
        @velocity = Default[:velocity]
        @outputs = outs
      end

      def play(n, duration)
        msg = note(n)
        output(msg)
        sleep(duration)
        off
        msg
      end

      def output(msg)
        @outputs.each { |o| o.puts(msg) }
        msg
      end
      
      # create a control change message
      def control_change(id, value, opts = {})
        props = message_properties(opts, :channel)
        cc = id.kind_of?(Numeric) ? ControlChange.new(props[:channel], id, value) : ControlChange[id].new(props[:channel], value)
        output(cc)
      end
      alias_method :cc, :control_change
      alias_method :c, :control_change

      # create a note message
      def note(id, opts = {})
        props = message_properties(opts, :channel, :velocity)
        note = id.kind_of?(Numeric) ? NoteOn.new(props[:channel], id, props[:velocity]) : NoteOn[id].new(props[:channel], props[:velocity])
        @last_note = note
        output(note)
      end
      alias_method :n, :note

      # create a note off message
      def note_off(id, opts = {})
        props = message_properties(opts, :channel, :velocity)
        no = id.kind_of?(Numeric) ? NoteOff.new(props[:channel], id, props[:velocity]) : NoteOff[id].new(props[:channel], props[:velocity])
        output(no)
      end
      alias_method :no, :note_off

      # create a MIDI message from a byte string, array of bytes, or list of bytes
      def parse(message)
        output(MIDIMessage.parse(message))
      end
      alias_method :p, :parse

      # create a program change message
      def program_change(program, opts = {})
        props = message_properties(opts, :channel)
        pc = MIDIMessage::ProgramChange.new(props[:channel], program)
        output(pc)
      end
      alias_method :pc, :program_change

      # create a note-off message from the last note-on message
      def off
        o = @last_note.to_note_off
        @last_note = nil
        output(o)
      end
      alias_method :o, :off

      def channel(val = nil)
        val.nil? ? @channel : @channel = val
      end

      def velocity(val = nil)
        val.nil? ? @velocity : @velocity = val
      end

      private

      def message_properties(opts, *props)
        output = {}
        props.each do |prop|
          output[prop] = opts[prop]
          self.send("#{prop.to_s}=", output[prop]) if self.send(prop.to_s).nil?
          output[prop] ||= self.send(prop.to_s)
        end
        output
      end

    end

  end

end