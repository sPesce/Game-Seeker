require_relative '../config/environment'


cli = CliApp.new
#any number != -1 (until exit condition)
inp = -999
until (inp == -1) do
    system("clear")
    inp = cli.main_menu
    case cli.menu_param
    when 0#update
        inp = cli.update_db_prompt
    when 1#search by game
        inp = cli.select_game_prompt
        inp = cli.get_info_on_game(inp)
    when 2#search by deal price
        inp = cli.find_cheapest_deals_prompt
    end
end





