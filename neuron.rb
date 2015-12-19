# neuron: input -> ... -> output -> hidden-layer(intermidiate neurons) * connectivity weight -> output-neuron (output layer)
#
# Input layer:


# Neuron
# - input
# - output
# - sum_inputs() + activation function
#     - Activation function: Sigmoid function: S-shaped curve
# - activation(function(sum)


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
    @neurons.each_with_index do |n, index|
      if values
        n.activate(values[index])
      else
        n.activate
      end
    end
  end

  def connect(targetLayer)
    @neurons.each do |sourceNeuron|
      targetLayer.neurons.each do |targetNeuron|
        sourceNeuron.connect(targetNeuron)
      end
    end
  end
end


class Network
  attr_accessor :inputLayer, :outputLayer, :hiddenLayers

  def initialize(sizes)
    # refactor this later...
    @inputLayer = Layer.new(sizes.shift)
    @outputLayer = Layer.new(sizes.pop)
    @hiddenLayers = sizes.map{|s| Layer.new(s)}
  
    @layers = [
      [@inputLayer],
      @hiddenLayers,
      [@outputLayer]
    ].flatten

    @layers.each_with_index do |layer, index|
      nextIndex = index + 1

      if @layers[nextIndex]
        layer.connect(@layers[nextIndex])
      end
    end
  end


  def activate(inputValues)
    @inputLayer.activate(inputValues)
    @hiddenLayers.each {|h| h.activate }
    @outputLayer.activate
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
inputLayer = Layer.new(2)
outputLayer = Layer.new(2)

#puts inputLayer.neurons.size
#puts outputLayer.neurons.size

inputLayer.connect(outputLayer)

inputLayer.activate([1,2])
outputLayer.activate

puts
puts "Input layer - outgoing connections"
inputLayer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end

puts
puts "Output layer - incoming connections"
outputLayer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end


#####################################################
puts
puts "*" * 80
puts "NETWORK"
net = Network.new([3,2,1])
net.activate([1,2, 3])

puts "INPUT"
net.inputLayer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end


puts "HIDDEN"
net.hiddenLayers.each do |layer|
  layer.neurons.each do |n|
    puts "in #{n.input}  out #{n.output}"
  end
end

puts "OUTPUT"
net.outputLayer.neurons.each do |n|
  puts "in #{n.input}  out #{n.output}"
end
