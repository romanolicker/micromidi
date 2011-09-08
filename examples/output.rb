#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

output = UniMIDI::Output.use(0)

MIDI.using(output) do
  note "C4"
  cc 5, 120
  play "C2", 3
end