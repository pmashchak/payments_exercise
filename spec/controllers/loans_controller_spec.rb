require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  let!(:loan) { create(:loan, :with_outstanding_balance) }

  describe '#index' do
    it 'returns all loans' do
      get :index
      expect(response).to be_success
      data = JSON.parse(response.body).first
      expect(data['id']).to eq(loan.id)
      expect(data['funded_amount']).to eq(loan.funded_amount.to_s)
      expect(data['due_amount']).to eq(loan.due_amount.to_s)
    end
  end

  describe '#show' do
    it 'returns a loan' do
      get :show, params: { id: loan.id }
      expect(response).to be_success
      data = JSON.parse(response.body)
      expect(data['id']).to eq(loan.id)
      expect(data['funded_amount']).to eq(loan.funded_amount.to_s)
      expect(data['due_amount']).to eq(loan.due_amount.to_s)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: loan.id + 1 }
        expect(response).to be_not_found
      end
    end
  end
end
