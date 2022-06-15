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

  def photo_thumb(photo)
    url_for(photo.photo.variant(:thumb)) if photo.photo.attached?
  end

  def photo_show(photo)
    url_for(photo.photo.variant(:show)) if photo.photo.attached?
  end

  def user_avatar_thumb(user)
    if user.avatar.attached?
      url_for(user.avatar.variant(:thumb))
    else
      asset_path('user.png', class: 'img-icon')
    end
  end

  def user_avatar(user)
    if user.avatar.attached?
      url_for(user.avatar.variant(:avatar))
    else
      asset_path('user.png')
    end
  end

  def event_thumb(event)
    photos = event.photos.persisted

    if photos.any?
      photo = photos.sample.photo
      url_for(photo.variant(:thumb)) if photo.attached?
    else
      asset_path('event_thumb.jpg')
    end
  end

  def event_photo(event)
    photos = event.photos.persisted

    if photos.any?
      photo = photos.sample.photo
      url_for(photo) if photo.attached?
    else
      asset_path('event.jpg')
    end
  end

  def fa_icon(icon_class)
    content_tag 'icon', '', class: "fa fa-#{icon_class}"
  end


end
