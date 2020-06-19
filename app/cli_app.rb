require 'tty-prompt'
require_relative '../config/environment'

class CliApp
    PROMPT = TTY::Prompt.new
    attr_reader :menu_param
                #-1:    exit
                #0:     update
                #1:     search games
                #2:     search deals
                #-5:    undefined, ,see run case branch
    
    def initialize()
        @menu_param = -2
        #a number never used 
    end

    #ask user to select a game, find its deals, print link
    def game_prompt
        get_info_on_game(select_game_prompt)
    end
    
    #update/by game/by deal price/EXIT
    def main_menu
        @menu_param = PROMPT.select("Choose a Task:",make_menu_choices)   
    end
    
    #update database?
    def update_db_prompt      
        flag_reset = PROMPT.yes?("Would you like to update your database?")    
        if flag_reset#fetch data from API if true
            GetJsonHashes.populate_tables
        end
    end
    
    #select price range then show all deals, then select to print link
    def deals_prompt
        choices = mk_price_range_choices
        inp = PROMPT.select("Select a price range:",choices)
        #clamp all deals by price
        clamped = Deal.clamp_price(inp)#alphebetize me
        #bad input
        if clamped.empty?
            system "clear"
            puts "\nSorry, no games in that range"
            @menu_param = deals_prompt#recursive
        else#good input
            system "clear"
            deal_choices = clamped.map{|deal| choice("#{deal.game.title} - $#{deal.sale_price}",deal)}
            inp = PROMPT.select("Select Deal:",deal_choices)      
            @menu_param = PROMPT.select("deal hyperlink: #{inp.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])
        end
    end
  private
  def choice(name,value)
      {name: name, value: value}
  end
 #choice hashes for main_menu 
  def make_menu_choices
      choices = 
      [
          choice("Update Db",0),
          choice("Find by Game Title",1),
          choice("Find by deal price",2),
          choice("Exit",-1)          
      ]
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
              #===============>       add  first, map inside, add last
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
  #choice hashes that are for narrowing down game search
  #by starting letter
  def mk_letters_choice_hashes    
      choice_array = ["A-D","E-H","I-L","M-P","Q-T","U-Z"]    
      x = choice_array.map do |c|
          choice(c,(c[0]..c[2]).to_a)
      end
  end

  #make choice hashes for games
  def mk_game_hash(games)
      g = games.map{|game|choice(game.title,game)}      
  end

  #selects a game by first letter
  def select_game_prompt
      inp = PROMPT.select("Select Game:",mk_letters_choice_hashes)
      game_group = Game.starting_with(inp)
      if game_group.empty?
        system "clear"
        puts "Sorry, no games in this list"
        #used to break because converting this function from returning + inputting
        #   (inp) to instance var (@menu_param) broke it during recursion
        return select_game_prompt
      end
      #input not bad:      
      @menu_param = PROMPT.select("Select Game:",mk_game_hash(game_group))
  end

  #get deal info on game prompt
  #select_game_prompt should be ran first
  def get_info_on_game(game)
      inp = PROMPT.select("Options for #{game.title}:",mk_game_choices)
      case inp
      when 1#user selected 'stores' for game
          puts "#{game.title} is sold at the following stores:\n\n"
          game.stores.each{|store|puts " - #{store.name}"}
          @menu_prompt = PROMPT.select("Continue?",[choice("Continue",0),choice("Exit",-1)])     
      when 2#user selected 'all deals' for game
          choices = game.deals.map{|deal| choice(" - $#{deal.sale_price} (#{deal.store.name})",deal)}        
          inp = PROMPT.select("Select a deal to get hyperlink:",choices)
          @menu_prompt = PROMPT.select("deal hyperlink: #{inp.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])        
      when 3#user selected 'best deal' for game
          puts "The cheapest deal for #{game.title} currently listed is:"
          #cheapest deal for this game
          cheapest = game.cheapest_deal
          puts "#{cheapest.sale_price} (#{cheapest.store.name})"
          @menu_prompt = PROMPT.select("deal hyperlink: #{cheapest.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])    
      end
  end
    #   #UNUSED/OLD
    #   def search_by_prompt
    #       choices = [choice("Search by Game Title",0),choice("Search by Price Range",1)]
    #       inp = PROMPT.select("Would you like to search deals by game title or price range?")
    #       if inp == 0
    #           selected_game = select_game_prompt
    #           get_info_on_game(selected_game,PROMPT)
    #       else
    #           deals_prompt
    #       end
    #   end
end
