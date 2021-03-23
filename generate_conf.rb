require 'erb'

class Button
	include ERB::Util
  attr_accessor :items, :template


	def initialize(number, text, action, template)
		@number = number
		@text = text
		@lclick = action
    @template = template
	end

  def render
    ERB.new(@template).result(binding)
  end

  def show
  	puts render
  end
end

def button_template
  <<~HEREDOC
  \n#-------------------------------------
  # Button <%= @number %>
  button = new
  button_text = <%= @text %>
  button_lclick_command = <%= @lclick %>
  button_rclick_command =
  button_mclick_command =
  button_uwheel_command =
  button_dwheel_command =
  button_font_color = #d41e9d 100
  button_padding = 0 0
  button_background_id = 0
  button_centered = 0
  button_max_icon_size = 0
  HEREDOC
end

normal_tint_buttons = {
  '-      up' =>
  "DISPLAY=':1' xdotool key Up",
  '-      copy' =>
  "DISPLAY=':1' xdotool key Control_L+c",
  '-      paste' =>
  "DISPLAY=':1' xdotool key Control_L+v",
  '-      down' =>
  "DISPLAY=':1' xdotool key Down",
  '-      enterrr' =>
  "DISPLAY=':1' xdotool key Return",
  '-      close tab' =>
  "DISPLAY=':1' xdotool key Control_L+w",
  '-      backspace ' =>
  "DISPLAY=':1' xdotool key BackSpace",
  '-      blabla(POC) panel' =>
  "DISPLAY=':1' ruby generate_conf.rb bla && killall -SIGUSR1 tint2"
}

blabla_tint_buttons = {
  '-      bla' =>
    `echo bla`,
  '-      blabla' =>
    `echo blabla`,
  '-      blablabla' =>
    `echo blablabla`,
  '-      normal panel' =>
    "DISPLAY=':1' ruby generate_conf.rb normal && killall -SIGUSR1 tint2"
}

def generate_conf(tint_buttons)
  static_content = File.open('static_tint_conf').read
  File.write('generated_tint2_conf', static_content)
  File.open('generated_tint2_conf', 'a') do |f|
    tint_buttons.each_with_index do |(key, value), index|
      f << Button.new(
          index + 1, key,
          value, button_template
        ).render
    end
  end
end

case ARGV[0]
when 'normal'
  generate_conf(normal_tint_buttons)
when 'bla'
  generate_conf(blabla_tint_buttons)
else
  puts 'Missing argument: button_set. Using normal buttons'
  generate_conf(normal_tint_buttons)
end
