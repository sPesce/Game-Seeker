require_relative '../config/environment'


cli = CliApp.new
#any number != -1 (until exit condition)
until (cli.menu_param == -1) do
    system("clear")
    cli.main_menu
    case cli.menu_param
    when 0#update
        cli.update_db_prompt
    when 1#search by game
        cli.game_prompt
    when 2#search by deal price
        cli.deals_prompt
    end
end





