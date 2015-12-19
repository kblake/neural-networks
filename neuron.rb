class Connection
  attr_reader :source, :weight

  def initialize(source, target)
    @source = source # neuron
    @target = target # neuron
    @weight = rand
  end

  def to_s
    "Connection: #{@source} #{@target} #{@weight}"
  end
end

class Neuron
  attr_accessor :input
  attr_reader :output, :incoming, :outgoing

  def initialize
    @incoming = []
    @outgoing = []
  end

  def activation_function(input)
    1 / (1+ Math.exp(-input))
  end

  def activate(value = nil)
    @input = value || incoming.reduce(0) do |sum, connection|
      sum + connection.source.output * connection.weight
    end

    @output = activation_function(input)
  end

  def connect(target)
    connection = Connection.new(self, target)
    outgoing << connection
    target.incoming << connection
  end
end

class Layer
  attr_accessor :neurons

  def initialize(size)
     @neurons = Array.new(size) { Neuron.new }
  end

  def activate(values = nil)
    values = Array(values) # coerce it to an array if nil

    @neurons.each_with_index do |neuron, index|
      neuron.activate(values[index])
    end
  end

  def connect(target_layer)
    @neurons.each do |source_neuron|
      target_layer.neurons.each do |target_neuron|
        source_neuron.connect(target_neuron)
      end
    end
  end
end


class Network
  attr_accessor :input_layer, :output_layer, :hidden_layers

  def initialize(sizes)
    @input_layer    = Layer.new(sizes.shift)
    @output_layer   = Layer.new(sizes.pop)
    @hidden_layers  = sizes.map{|s| Layer.new(s)}
  
    connect_layers
  end


  def activate(inputValues)
    @input_layer.activate(inputValues)
    @hidden_layers.each {|hidden_layer| hidden_layer.activate }
    @output_layer.activate
  end

  private

  def connect_layers
    layers = [
      [@input_layer],
      @hidden_layers,
      [@output_layer]
    ].flatten

    layers.each_with_index do |layer, index|
      nextIndex = index + 1

      if layers[nextIndex]
        layer.connect(layers[nextIndex])
      end
    end
  end
end


neuronA = Neuron.new
neuronB = Neuron.new

neuronA.connect(neuronB)

neuronA.activate(10)
puts neuronA.output

neuronB.activate
puts neuronB.output


inputs = [1,1,1]
layer = Layer.new(inputs.size)
puts layer.neurons

layer.activate(inputs)

layer.neurons.each do |n|
  puts "input - #{n.input}, out - #{n.output}"
end


###############################################
input_layer = Layer.new(2)
output_layer = Layer.new(2)

#puts input_layer.neurons.size
#puts output_layer.neurons.size

input_layer.connect(output_layer)

input_layer.activate([1,2])
output_layer.activate

puts
puts "Input layer - outgoing connections"
input_layer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end

puts
puts "Output layer - incoming connections"
output_layer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end


#####################################################
puts
puts "*" * 80
puts "NETWORK"
net = Network.new([3,2,1])
net.activate([1,2, 3])

puts "INPUT"
net.input_layer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end


puts "HIDDEN"
net.hidden_layers.each do |layer|
  layer.neurons.each do |n|
    puts "in #{n.input}  out #{n.output}"
  end
end

puts "OUTPUT"
net.output_layer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end
