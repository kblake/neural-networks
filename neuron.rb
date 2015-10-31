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
    @weight = 0.5
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
    input = value || incoming.reduce(0) do |sum, connection|
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


neuronA = Neuron.new
neuronB = Neuron.new
#neuronA.input = 2

neuronA.connect(neuronB)

neuronA.activate(10)
puts neuronA.output

neuronB.activate
puts neuronB.output

#puts neuronA.outgoing
#puts neuronB.incoming



