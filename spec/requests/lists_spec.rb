require 'rails_helper'

RSpec.describe 'Lists API', type: :request do
  # initialize user
  let(:user) { create(:user) }
  # initialize user
  let(:member) { create(:member) }
  #create 10 lists
  let!(:lists) { create_list(:list, 10, created_by: user ,:users => [user]) }
  #create 10 cards
  let!(:cards) { create_list(:card, 10,list: lists.first , created_by: user ) }
  #let first list id
  let(:list_id) { lists.first.id }
  #let user member id
  let(:list_member_id) { lists.first.users.last.id }
  #list members
  let(:members) { lists.first.users }
  # authorize request
  let(:headers) { valid_headers }

  # Test suite for GET /lists
  describe 'GET /lists' do
    # make HTTP get request before each example
    before { get '/lists', params: {}, headers: headers }
    it 'returns lists' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /lists/:id
  describe 'GET /lists/:id' do
    before { get "/lists/#{list_id}" , params: {}, headers: headers}

    context 'when the record exists' do
      let(:extra_user) { create(:user) }
      let(:card) { create(:card,list: lists.first , created_by: extra_user ) }
      it 'returns the cards' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:list_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find List with 'id'=#{list_id}/)
      end
    end
  end

  # # Test suite for POST /lists
  describe 'POST /lists' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm' }.to_json }

    context 'when the request is valid' do

      before { post '/lists', params: valid_attributes  ,headers: headers }

      it 'creates a list' do


        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/lists', params: { }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # # Test suite for PUT /lists/:id
  describe 'PUT /lists/:id' do
    let(:valid_attributes) { { title: 'Shopping' }.to_json }

    context 'when the record exists' do
      before { put "/lists/#{list_id}", params: valid_attributes, headers: headers  }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /lists/:id
  describe 'DELETE /lists/:id' do
    before { delete "/lists/#{list_id}" , params: {}, headers: headers}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  describe 'Assign User /lists/:id/assign_member/:user_id ' do
    before { post "/lists/#{list_id}/assign_member/#{user.id}" , params: {}, headers: headers}

    it 'returns status code 204' do
      expect(list_member_id).to eq(user.id)
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  describe 'Unassign User /lists/:id/unassign_member/:user_id ' do
    before { post "/lists/#{list_id}/unassign_member/#{member.id}" , params: {}, headers: headers}

    it 'returns status code 204' do
      expect(members).not_to include(member)
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end