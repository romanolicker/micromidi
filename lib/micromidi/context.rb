#!/usr/bin/env ruby
#

module MicroMIDI
  
  class Context
    
    include Instructions::Composite
            
    def initialize(ins, outs, &block)
      
      @state = State.new(ins, outs)
      
      @instructions = {
        :input => Instructions::Input.new(@state),      
        :message => Instructions::Message.new(@state),
        :output => Instructions::Output.new(@state),
        :sticky => Instructions::Sticky.new(@state)
      }
       
      self.instance_eval(&block)
    end
    
    def method_missing(m, *a, &b)
      delegated = false
      outp = nil
      if @instructions[:message].respond_to?(m)
        outp = @instructions[:output].output(@instructions[:message].send(m, *a, &b))
        delegated = true
      else
        [@instructions[:input], @instructions[:output], @instructions[:sticky]].each do |dsl| 
          if dsl.respond_to?(m)
            outp = dsl.send(m, *a, &b)
            delegated = true
          end
        end
      end
      @state.record(outp)
      delegated ? outp : super
    end
        
  end
end