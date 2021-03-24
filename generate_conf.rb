require 'erb'

class Button
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

def key(k)
  "DISPLAY=':1' xdotool key #{k}"
end

def switch_panel(p)
  "DISPLAY=':1' ruby generate_conf.rb #{p} && killall -SIGUSR1 tint2"
end

def generate_conf(tint_buttons)
  static_content = File.open('static_tint_conf').read
  File.write('generated_tint2_conf', static_content)
  File.open('generated_tint2_conf', 'a') do |f|
    tint_buttons.each_with_index do |(key, value), index|
      f << Button.new(
        index + 1, "-      #{key}",
        value, button_template
      ).render
    end
  end
end

panels = {
  normal: {
    up: key('Up'),
    copy: key('Control_L+c'),
    paste: key('Control_L+v'),
    down: key('Down'),
    enter: key('Return'),
    close_tab: key('Control_L+w'),
    backspace: key('BackSpace'),
    wasd_panel: switch_panel(:wasd)
  },
  wasd: {
    w: key('w'),
    a: key('a'),
    s: key('s'),
    d: key('d'),
    normal_panel: switch_panel(:normal)
  }
}

if ARGV[0]
  generate_conf(panels[ARGV[0].to_sym])
else
  puts 'Missing argument: button_set.'
end
