require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  describe 'GET new' do
    let(:register_user_form_class) { class_double(RegisterUserForm).as_stubbed_const }
    let(:register_user_form_object) { object_double(RegisterUserForm) }

    before :each do
      allow(register_user_form_class).to receive(:new).and_return(register_user_form_object)
      get :new
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns RegisterUserForm to @register_user_form' do
      expect(assigns(:register_user_form)).to eq(register_user_form_object)
    end
  end

  describe 'POST create' do
    let(:email) { 'email@example.com' }
    let(:password) { 'password' }

    let(:register_user_params) { { email: email, password: password, password_confirmation: password } }
    let(:register_user_form_class) { class_double('RegisterUserForm').as_stubbed_const }
    let(:register_user_form_object) { double('RegisterUserForm') }
    let(:user_object) { build(:user) }

    before :each do
      allow(register_user_form_object).to receive(:valid?).and_return(true)
      allow(register_user_form_class).to receive(:run).and_return(register_user_form_object)
      allow(register_user_form_object).to receive(:result).and_return(user_object)
    end

    it 'attempts to creates a new user' do
      post :create, register_user: register_user_params
      expect(assigns(:register_user)).to eq(register_user_form_object)
    end

    it 'attempts to log the user in' do
      expect(controller).to receive(:auto_login).with(user_object)
      post :create, register_user: register_user_params
    end

    it 'redirects to the dashboard path if successful' do
      post :create, register_user: register_user_params
      expect(response).to redirect_to(dashboard_path)
    end

    it 'renders the new template if unsuccessful' do
      allow(register_user_form_object).to receive(:valid?).and_return(false)
      post :create, register_user: register_user_params
      expect(response).to render_template(:new)
    end
  end
end
