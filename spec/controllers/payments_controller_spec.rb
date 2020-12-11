require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let!(:loan) { create(:loan, :with_outstanding_balance) }
  let(:payment) { loan.payments.first }

  describe '#index' do
    it 'returns all payments within a loan' do
      get :index, params: { loan_id: loan.id }
      expect(response).to be_success
      data = JSON.parse(response.body)
      expect(data).to include(include('id' => payment.id, 'payment_amount' => payment.payment_amount.to_s, 'loan_id' => loan.id))
    end
  end

  describe '#show' do
    it 'returns a payment' do
      get :show, params: { loan_id: loan.id, id: payment.id }
      expect(response).to be_success
      data = JSON.parse(response.body)
      expect(data['id']).to eq(payment.id)
      expect(data['payment_amount']).to eq(payment.payment_amount.to_s)
      expect(data['loan_id']).to eq(loan.id)
    end

    context 'if the payment is not found' do
      it 'responds with a 404' do
        get :show, params: { loan_id: loan.id, id: payment.id + 10 }
        expect(response).to be_not_found
      end
    end
  end

  describe '#create' do
    let(:payment_amount) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    let(:payment_params) { { loan_id: loan.id, payment: { payment_amount: payment_amount } } }

    it 'creates a payment' do
      expect {
        post :create, params: payment_params
      }.to change(Payment, :count)

      expect(response).to be_success
      data = JSON.parse(response.body)
      expect(data['payment_amount']).to eq(payment_amount.to_s)
      expect(data['loan_id']).to eq(loan.id)
    end

    context 'when payment amount > that due_amout' do
      let(:payment_amount) { loan.funded_amount + Faker::Number.decimal(l_digits: 2, r_digits: 2) }

      it 'renders validation errors' do
        expect {
          post :create, params: payment_params
        }.not_to change(Payment, :count)
        expect(response).to be_bad_request
        data = JSON.parse(response.body)
        expect(data).to include('Payment amount less or equal due_amount')
      end
    end
  end
end
