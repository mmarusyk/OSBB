require 'rails_helper'

RSpec.describe Account::Admin::OsbbsController, type: :controller do
  render_views

  let!(:osbb) { create(:osbb) }
  let!(:simple) { create(:user, role: :simple) }
  let!(:valid_params) { attributes_for :osbb }
  let!(:invalid_params) { { name: '' } }

  login_admin

  describe 'GET#index' do
    it 'assigns osbbs and renders template!' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:osbbs)).to eq([osbb])
      expect(response).to render_template('index')
    end
  end

  describe 'GET#show' do
    include_examples 'return not found exception', Osbb
  end

  describe 'GET#new' do
    before { get :new }

    it 'returns success for admin and assigns osbb' do
      expect(response).to have_http_status(:success)
      expect(assigns(:osbb)).to be_a_new(Osbb)
    end

    it 'returns success and simple user assigns osbb' do
      sign_in simple
      expect(response).to have_http_status(:success)
      expect(assigns(:osbb)).to be_a_new(Osbb)
    end
  end

  describe 'POST#create' do
    context 'when admin creates osbb with valid params' do
      subject { post :create, params: { osbb: valid_params } }

      it 'creates a new osbb' do
        expect { subject }.to change(Osbb, :count).by(1)
      end

      it 'is still an admin' do
        expect { subject }.to change(User.lead, :count).by(0)
      end

      it 'redirects to the created osbb' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_osbb_path(Osbb.last))
      end
    end

    context 'when simple user creates osbb with valid params' do
      subject { post :create, params: { osbb: valid_params } }

      before { sign_in simple }

      it 'creates a new osbb' do
        expect { subject }.to change(Osbb, :count).by(1)
      end

      it 'become OSBB lead' do
        expect { subject }.to change(User.lead, :count).by(1)
      end

      it 'redirects to the created osbb' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_osbb_path(Osbb.last))
      end
    end

    context 'with invalid params' do
      it 'do not create a new osbb' do
        sign_in simple
        expect do
          post :create, params: { osbb: invalid_params }
        end.not_to change(Osbb, :count)
      end
    end
  end

  describe 'GET#edit' do
    before do
      get :edit, params: { id: osbb.id }
    end

    it 'returns http success and assigns osbb' do
      expect(response).to have_http_status(:success)
      expect(assigns(:osbb)).to eq(osbb)
    end
  end

  describe 'PUT#update' do
    context 'with valid params' do
      before do
        put :update, params: { id: osbb.id,
                               osbb: valid_params.merge!(name: 'Example',
                                                         phone: '0123456789',
                                                         email: 'example@email.com') }
      end

      it 'assigns the osbb' do
        expect(assigns(:osbb)).to eq(osbb)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_osbb_path(osbb))
      end

      it 'updates osbb attributes' do
        osbb.reload
        expect(osbb.name).to eq(valid_params[:name])
        expect(osbb.phone).to eq(valid_params[:phone])
        expect(osbb.email).to eq(valid_params[:email])
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid params' do
      it 'does not change osbb' do
        expect do
          put :update, params: { id: osbb.id, osbb: invalid_params }
        end.not_to change { osbb.reload.name }
        expect do
          put :update, params: { id: osbb.id, osbb: invalid_params }
        end.not_to change { osbb.reload.phone }
      end
    end
  end

  describe 'DELETE#destroy' do
    it 'destroys the osbb and redirects to index' do
      expect { delete :destroy, params: { id: osbb.id } }
        .to change(Osbb, :count).by(-1)
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(%i[account admin osbbs])
      expect(flash[:danger]).to be_present
    end
  end
end
