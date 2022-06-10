module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info' }
      .stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show") do
        concat content_tag(:button, '', type: 'button', class: 'btn-close', data: { bs_dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def user_avatar_thumb(user)
    if user.avatar.attached?
      url_for(user.avatar.variant(:thumb))
    else
      asset_path('user.png')
    end
  end

  def user_avatar(user)
    if user.avatar.attached?
      url_for(user.avatar.variant(:avatar))
    else
      asset_path('user.png')
    end
  end


  def fa_icon(icon_class)
    content_tag 'icon', '', class: "fa fa-#{icon_class}"
  end
end
