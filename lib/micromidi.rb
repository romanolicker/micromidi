#!/usr/bin/env ruby
#
# micromidi
# A Ruby DSL for MIDI
#
# (c)2011 Ari Russo 
# licensed under the Apache 2.0 License
#

# included libs
require 'midi-eye'
require 'midi-message'
require 'unimidi'

module MicroMIDI
  
  VERSION = "0.0.1"
  
  module Instructions
  end
  
  def self.message(*args, &block)
    ins, outs = *process_devices(args)
    MicroMIDI::Context.new(ins, outs, &block)
  end
  
  private
  
  def self.process_devices(args)
    ins = args.find_all { |device| device.direction == :input }
    outs = args.find_all { |device| device.direction == :output }
    [ins, outs]    
  end  
  
end
MIDI = MicroMIDI

# modules
require 'micromidi/instructions/composite'

# classes
require 'micromidi/context'
require 'micromidi/state'
require 'micromidi/instructions/input'
require 'micromidi/instructions/message'
require 'micromidi/instructions/output'
require 'micromidi/instructions/sticky'

# re-open
require 'micromidi/instructions/shorthand'