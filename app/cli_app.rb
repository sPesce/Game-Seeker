require 'tty-prompt'
require_relative '../config/environment'

class CliApp
  PROMPT = TTY::Prompt.new
  attr_reader :menu_param

  def choice(name,value)
      {name: name, value: value}
  end
  
  def make_menu_choices
      choices = 
      [
          choice("Update Db",0),
          choice("Find by Game Title",1),
          choice("Find by deal price",2),
          choice("Exit",-1)          
      ]
  end
  def main_menu
    @menu_param = PROMPT.select("Choose a Task:",make_menu_choices)   
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
  end

  def mk_game_hash(games)
      g = games.map{|game|choice(game.title,game)}      
  end

  #update database?
  def update_db_prompt      
      flag_reset = PROMPT.yes?("Would you like to update your database?")    
      if flag_reset#fetch data from API if true
          GetJsonHashes.populate_tables
      end
  end


  def select_game_prompt
      inp = PROMPT.select("Select Game:",mk_letters_choice_hashes)
      game_group = Game.starting_with(inp)
      @menu_param = PROMPT.select("Select Game:",mk_game_hash(game_group))
  end

  def get_info_on_game(game)
      inp = PROMPT.select("Options for #{game.title}:",mk_game_choices)
      case inp
      when 1
          puts "#{game.title} is sold at the following stores:\n\n"
          game.stores.each{|store|puts " - #{store.name}"}
          @menu_prompt = PROMPT.select("Continue?",[choice("Continue",0),choice("Exit",-1)])     
      when 2
          choices = game.deals.map{|deal| choice(" - $#{deal.sale_price} (#{deal.store.name})",deal)}        
          inp = PROMPT.select("Select a deal to get hyperlink:",choices)
          @menu_prompt = PROMPT.select("deal hyperlink: #{inp.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])        
      when 3
          puts "The cheapest deal for #{game.title} currently listed is:"
          #cheapest deal for this game
          cheapest = game.cheapest_deal
          puts "#{cheapest.sale_price} (#{cheapest.store.name})"
          @menu_prompt = PROMPT.select("deal hyperlink: #{cheapest.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])    
      end

  end

  def search_by_prompt
      choices = [choice("Search by Game Title",0),choice("Search by Price Range",1)]
      inp = PROMPT.select("Would you like to search deals by game title or price range?")
      if inp == 0
          selected_game = select_game_prompt
          get_info_on_game(selected_game,PROMPT)
      else
          find_cheapest_deals_prompt
      end
  end


  def find_cheapest_deals_prompt
      choices = mk_price_range_choices
      inp = PROMPT.select("Select a price range:",choices)
      clamped = Deal.clamp_price(inp)
      if clamped.empty?
          system "clear"
          puts "\nSorry, no games in that range"
          @menu_param = find_cheapest_deals_prompt
      else
          system "clear"
          deal_choices = clamped.map{|deal| choice("#{deal.game.title} - $#{deal.sale_price}",deal)}
          inp = PROMPT.select("Select Deal:",deal_choices)      
          @menu_param = PROMPT.select("deal hyperlink: #{inp.mk_hyperlink}",[choice("Continue",0),choice("Exit",-1)])
      end
  end
end
