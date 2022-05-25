class SessionsController < Devise::SessionsController
  def destroy
    resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(root_path)
  end
end