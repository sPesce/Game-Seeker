require_relative '../config/environment'

prompt = TTY::Prompt.new
def choice(name,value)
    {name: name, value: value}
end
#helper for find_cheapest_deal
#makes the choice array
def mk_price_range_choices
    prices =
    [
        [45,60],
        [30,45],
        [15,30],
        [10,15],
        [5,10]
    ]
    choices = []
            #===============>
    choices                      << [choice("$60 and up",prices[0])]#first choice
    prices.each{|limits| choices << choice("$#{limits[0]} - $#{limits[1]}",limits)}
    choices                      << choice("$5 and lower",[0,5])#last choice
    choices
end
#helper for get_info_on_game
#makes the choice array
def mk_game_choices
    [
        choice("Show stores",1),
        choice("Show all deals",2),
        choice("Show cheapest deal",3)
    ]
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
    #exit_option(g)
end

#update database?
def update_db_prompt
    prompt = TTY::Prompt.new#
    flag_reset = prompt.yes?("Would you like to update your database?")    
    if flag_reset#fetch data from API if true
        GetJsonHashes.populate_tables
    end
end


def select_game_prompt
    prompt = TTY::Prompt.new
    inp = prompt.select("Select Game:",mk_letters_choice_hashes)
    game_group = games_starting_with(inp)
    inp = prompt.select("Select Game:",mk_game_hash(game_group))
end

def games_starting_with(chars) 
    Game.where("substr(title, 1, 1) IN (?)", chars)
end#---------------------------------------------------------------

def get_info_on_game(game)
    prompt = TTY::Prompt.new
    inp = prompt.select("Options for #{game.title}:",mk_game_choices)
    case inp
    when 1
        puts "#{game.title} is sold at the following stores:\n\n"
        game.stores.each{|store|puts " - #{store.name}"}
        return prompt.select("Continue?",[choice("Continue",0),choice("Exit",-1)])     
    when 2
        choices = game.deals.map{|deal| choice(" - $#{deal.sale_price} (#{deal.store.name})",deal)}        
        inp = prompt.select("Select a deal to get hyperlink:",choices)
        return prompt.select("deal hyperlink: #{inp.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])        
    when 3
        puts "The cheapest deal for #{game.title} currently listed is:"
        #cheapest deal for this game
        cheapest = game.cheapest_deal
        puts "\n - #{cheapest.sale_price} (#{cheapest.store.name})"
        return prompt.select("deal hyperlink: #{cheapest.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])    
    end
    puts ""

end

def search_by_prompt
    prompt = TTY::Prompt.new
    choices = [choice("Search by Game Title",0),choice("Search by Price Range",1)]
    inp = prompt.select("Would you like to search deals by game title or price range?")
    if inp == 0
        selected_game = select_game_prompt
        get_info_on_game(selected_game,prompt)
    else
        find_cheapest_deals_prompt
    end
end


def find_cheapest_deals_prompt
    prompt = TTY::Prompt.new
    choices = mk_price_range_choices
    inp = prompt.select("Select a price range:",choices)
    clamped = Deal.clamp_price(inp)
    if clamped.empty?
        Puts "\nSorry, no games in that range"
        return find_cheapest_deals_prompt
    else
        deal_choices = clamped.map{|deal| choice("#{deal.game.title} - $#{deal.sale_price}",deal)}
        inp = prompt.select("Select Deal:",deal_choices)
        puts""        
        return prompt.select("deal hyperlink: #{inp.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])
    end
end

##TODO: ERROR HANDLING FOR NO OPTIONS
pr = TTY::Prompt.new
choices = 
[
    choice("Update Db",0),
    choice("Find by Game Title",1),
    choice("Find by deal price",2),
    choice("Exit",-1)
    
]

#any number != -1 (until exit condition)
inp = -999
until (inp == -1) do  
    inp = pr.select("Choose a Task:",choices)
    case inp
    when 0#update
        update_db_prompt
    when 1#search by game
        inp = select_game_prompt
        inp = get_info_on_game(inp)
    when 2#search by deal price
        inp = find_cheapest_deals_prompt
    end
end





