module WordsHelper

  def option_for_category
    Category.all.collect {|c| [c.name, c.id]}
  end
end
