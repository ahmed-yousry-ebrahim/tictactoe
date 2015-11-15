require 'rspec'
require 'spec_helper'
require 'rails_helper'

feature "As a user I should be able to create a new game" do

  scenario "new game page loads correctly" do
    visit new_game_path
    expect(page).to have_http_status(200)
    expect(page).to have_content I18n.t("games.new")
  end

  scenario "inputting valid player names result in creating a new game" do
    first_player = FactoryGirl.build(:player)
    second_player = FactoryGirl.build(:player)
    visit new_game_path
    fill_in I18n.t("games.fp_name"), with: first_player.name
    fill_in I18n.t("games.sp_name"), with: second_player.name
    click_button I18n.t("games.create")
    expect(page).to have_content I18n.t("games.successfully_created")
  end

  scenario "not inputting valid player names result in error" do
    first_player = FactoryGirl.build(:player)
    game = FactoryGirl.create(:game)
    visit new_game_path
    fill_in I18n.t("games.fp_name"), with: first_player.name
    click_button I18n.t("games.create")
    expect(page).to have_content "error"
  end
end

feature "As a user I should be able to play the game after creation" do
  before do
    @game_round = FactoryGirl.create(:round)
    @game_round.current_player = @game_round.game.first_player
    @game_round.save
  end
  scenario "game board loads correctly" do
    visit game_path(:id => @game_round.game.id)
    expect(page).to have_selector(".game-board")
  end

  scenario "game board has the player names" do
    visit game_path(:id => @game_round.game.id)
    expect(page).to have_content @game_round.game.first_player.name
    expect(page).to have_content @game_round.game.second_player.name
  end

  scenario "new game round will not be created if the current round is not finished" do
    game = @game_round.game
    visit new_game_round_path(:game_id => game.id)
    expect(game.rounds.count).to eq(1)
  end

  scenario "new game round will be created if the current round is finished" do
    game = @game_round.game
    @game_round.result = "draw"
    @game_round.save
    visit new_game_round_path(:game_id => game.id)
    expect(game.rounds.count).to eq(2)
  end

end

feature "As a player I should be able to win the game putting my symbol in a row, column or a diagonal on the board" do

  scenario "player 1 wins after completing a column", :js=>true do
    first_player = FactoryGirl.build(:player)
    second_player = FactoryGirl.build(:player)
    visit new_game_path
    fill_in I18n.t("games.fp_name"), with: first_player.name
    fill_in I18n.t("games.sp_name"), with: second_player.name
    click_button I18n.t("games.create")
    find("td[data-row='0'][data-column='0']").click
    find("td[data-row='1'][data-column='1']").click
    find("td[data-row='1'][data-column='0']").click
    find("td[data-row='2'][data-column='2']").click
    find("td[data-row='2'][data-column='0']").click
    expect(page).to have_content I18n.t("games.player_win",:player_name=>first_player.name)
  end

  scenario "player 2 wins after completing a row", :js=>true do
    first_player = FactoryGirl.build(:player)
    second_player = FactoryGirl.build(:player)
    visit new_game_path
    fill_in I18n.t("games.fp_name"), with: first_player.name
    fill_in I18n.t("games.sp_name"), with: second_player.name
    click_button I18n.t("games.create")
    find("td[data-row='0'][data-column='0']").click
    find("td[data-row='1'][data-column='1']").click
    find("td[data-row='0'][data-column='1']").click
    find("td[data-row='1'][data-column='0']").click
    find("td[data-row='2'][data-column='2']").click
    find("td[data-row='1'][data-column='2']").click
    expect(page).to have_content I18n.t("games.player_win",:player_name=>second_player.name)
  end

  scenario "no more cells are left so game is a draw", :js=>true do
    first_player = FactoryGirl.build(:player)
    second_player = FactoryGirl.build(:player)
    visit new_game_path
    fill_in I18n.t("games.fp_name"), with: first_player.name
    fill_in I18n.t("games.sp_name"), with: second_player.name
    click_button I18n.t("games.create")
    find("td[data-row='0'][data-column='0']").click
    find("td[data-row='1'][data-column='1']").click
    find("td[data-row='0'][data-column='1']").click
    find("td[data-row='0'][data-column='2']").click
    find("td[data-row='2'][data-column='0']").click
    find("td[data-row='1'][data-column='0']").click
    find("td[data-row='1'][data-column='2']").click
    find("td[data-row='2'][data-column='1']").click
    find("td[data-row='2'][data-column='2']").click
    expect(page).to have_content I18n.t("games.draw")
  end
end