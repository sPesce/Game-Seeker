require_relative '../config/environment'

prompt = TTY::Prompt.new
def choice(name,value)
    {name: name, value: value}
end

def exit_option(arr)
    arr << choice("=EXIT=",0)
end
def mk_letters_choice_hashes    
    choice_array = ["A-D","E-H","I-L","M-P","Q-T","U-Z"]    
    x = choice_array.map do |c|
        choice(c,(c[0]..c[2]).to_a)
    end
    exit_option(x)
end

def mk_game_hash(games)
    g = games.map{|game|choice(game.title,game)}
    exit_option(g)
end

def mk_game_choices
    [
        choice("Show stores",1),
        choice("Show all deals",2),
        choice("Show cheapest deal",3)
    ]
end

def update_db_prompt(prompt)
    flag_reset = prompt.yes?("Would you like to update your database?")
    if flag_reset == 'y'
        GetJsonHashes.populate_tables
    end
end

def select_game_prompt(prompt)
    inp = prompt.select("Select Game:",mk_letters_choice_hashes)
    game_group = games_starting_with(inp)
    inp = prompt.select("Select Game:",mk_game_hash(game_group))
end

def games_starting_with(chars) 
    Game.where("substr(title, 1, 1) IN (?)", chars)
end#---------------------------------------------------------------

def get_info_on_game(game,prompt)
    inp = prompt.select("Options for #{game.title}:",mk_game_choices)
    case inp
    when 1
        puts "#{game.title} is sold at the following stores:\n\n"
        game.stores.each{|store|puts " - #{store.name}"}        
    when 2
        puts "The following deals were found for #{game.title}:\n\n"
        game.deals.each{|deal|puts " - $#{deal.sale_price} (#{deal.store.name})"}        
    when 3
        puts "The cheapest deal for #{game.title} currently listed is:"
        puts "\n - #{game.cheapest_deal.sale_price} (#{game.cheapest_deal.store.name})"
    end
    puts ""

end

#---------------
#TODO: feed deals back into prompt and ask user to select one
# then once the list is narrowed down to one deal,
#it should give the option to link the user to deal hyperlink
#make sure we use https://www.cheapshark.com/redirect?dealID={id}
#redirect link as per cheapsharks request!
#--------------

#update_db_prompt(prompt)
selected_game = select_game_prompt(prompt)
get_info_on_game(selected_game,prompt)




