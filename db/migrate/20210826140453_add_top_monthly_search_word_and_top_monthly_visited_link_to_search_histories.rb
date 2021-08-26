class AddTopMonthlySearchWordAndTopMonthlyVisitedLinkToSearchHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :search_histories, :top_monthly_search_word, :text, array: true, default: []
    add_column :search_histories, :top_monthly_visited_link, :text, array: true, default: []
  end
end
