require_relative './free_text_parser.rb'
class TransitionTable
  class TransitionError < RuntimeError
    def initialize(state, input)
      super "No transition from state #{state.inspect} for input #{input.inspect}"
    end
  end

  def initialize(transitions)
    @transitions = transitions
  end

  def call(state, input)
    @transitions.fetch([state, input])
  rescue KeyError
    raise TransitionError.new(state, input)
  end
end

class StateMachine
  def initialize(transition_function, initial_state)
    @transition_function = transition_function
    @state = initial_state
  end

  attr_reader :state

  def send_input(input)
    @state, output = @transition_function.call(@state, input)
    output
  end
end

class YashCheatSheetParseModel
  STATE_TRANSITIONS = TransitionTable.new(
    # State         Input     Next state      Output
    [:awaiting_input, :ends_with_hash_character] => [:read_region_header,  :store_region],
    [:awaiting_input, :text_line] => [:read_description,  :store_description],
    [:awaiting_input, :blank_line] => [:awaiting_input,  :do_nothing],
    [:read_region_header, :visual_separator] => [:read_region_header,  :do_nothing],
    [:read_region_header, :blank_line] => [:read_region_header,  :do_nothing],
    [:read_region_header, :text_line] => [:read_description,  :store_description],
    [:read_description, :text_line] => [:read_command,  :store_command],
    [:read_description, :blank_line] => [:awaiting_input,  :commit],
    [:read_command, :text_line] => [:read_command,  :store_command],
    [:read_command, :blank_line] => [:awaiting_input,  :commit]
  )

  def initialize(reader)
    @state_machine = StateMachine.new(STATE_TRANSITIONS, :awaiting_input)
    @reader = reader
  end

  def handle_event(event)
    action = @state_machine.send_input(event)
    send(action) unless action.nil?
  end

  def do_nothing
    puts "Doing Nothing"
  end

  def store_region
    puts "Storing Region"
    @reader.set_category
  end

  def store_description
    puts "Store Description"
    @reader.set_description
  end

  def store_command
    puts "Store Command"
    @reader.set_command
  end

  def commit
    puts "Comitting what's read"
    @reader.finalize_cheat
  end
end
