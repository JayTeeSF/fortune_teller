require_relative "fortune_teller/chooser"
module FortuneTeller
  class Game
    def jail_reveal
      Reveal.new( "Oops, you're in Jail!" )
    end

    def mud_reveal
      Reveal.new( "Oops, you're in the mud!" )
    end

    def cookie_reveal
      Reveal.new( "Wow, you get a cookie!" )
    end

    def final_choices
      @final_choices ||= [
        Panel.new( "blue", choice([jail_reveal, mud_reveal, cookie_reveal]) ),
        Panel.new( "green", choice([jail_reveal, mud_reveal, cookie_reveal]) ),
        Panel.new( "pink",  choice([jail_reveal, mud_reveal, cookie_reveal]) ),
      ]
    end

    def final_choice_1
      @final_choice_1 ||= choice(final_choices)
    end

    def final_choice_2
      @final_choice_2 ||= choice(final_choices - [ final_choice_1 ])
    end

    def choice(choices)
      choices[rand(choices.size)]
    end

    def level_three_chooser
      Chooser.new( final_choice_1, final_choice_2 )
    end

    def level_two_chooser
      Chooser.new(
        Panel.new( "9", level_three_chooser ),
        Panel.new( "7", level_three_chooser ),
        Panel.new( "3", level_three_chooser ),
        Panel.new( "5", level_three_chooser ),
      )
    end

    def level_one_chooser
      Chooser.new(
        Panel.new( "bird", level_two_chooser ),
        Panel.new( "dog", level_two_chooser ),
        Panel.new( "chicken", level_two_chooser ),
        Panel.new( "mouse", level_two_chooser )
      )
    end

    def run
      level_one_chooser.choose
    end
  end
end
