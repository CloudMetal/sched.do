require 'spec_helper'

describe SessionsController, '#create' do
  include OmniAuthHelper

  it 'does not require login' do
    stub_omniauth_env

    post :create

    should_not deny_access
  end

  it 'does not create a new user if one exists' do
    stub_omniauth_env

    post :create
    post :destroy
    post :create

    User.count.should == 1
  end

  it 'fetches new Yammer user data' do
    user_data_fetcher = stub(:fetch)
    UserDataFetcher.stubs(new: user_data_fetcher)
    stub_omniauth_env

    post :create

    UserDataFetcher.should have_received(:new)
    user_data_fetcher.should have_received(:fetch)
  end

  it 'signs out a guest when a Yammer user signs in' do
    session[:name] = 'Joe Schmoe'
    session[:email] = 'joe@example.com'
    stub_omniauth_env

    post :create

    session[:name].should be_nil
    session[:email].should be_nil
  end

  it 'drops a yammer_user_id cookie' do
    cookies.signed[:yammer_user_id].should be_nil
    stub_omniauth_env

    post :create

    cookies.signed[:yammer_user_id].should be_present
  end

  it 'redirects to the new_event_path if return_to is blank' do
    session[:return_to] = nil
    stub_omniauth_env

    post :create

    should redirect_to new_event_path
  end

  it 'deletes return_to if not blank' do
    session[:return_to] = new_event_path
    stub_omniauth_env

    post :create

    session[:return_to].should be_nil
  end
end


describe SessionsController, '#destroy' do
  include OmniAuthHelper

  it 'sets current_user to nil' do
    session[:name] = 'Joe Schmoe'
    session[:email] = 'joe@example.com'
    stub_omniauth_env

    delete :destroy

    session[:name].should be_nil
    session[:email].should be_nil
  end

  it 'deletes the yammer_user_id cookie' do
    cookies.signed[:yammer_user_id] = '123'

    delete :destroy

    cookies.signed[:yammer_user_id].should be_nil
  end

  it 'redirects to the root path' do
    stub_omniauth_env
    post :create

    delete :destroy

    should redirect_to root_path
  end
end
