module ApplicationHelper
  def full_title page_title
    base_title = "Framgia E-learning System"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end
end
