require 'rails_helper'

describe Payment, type: :model do
  subject { build(:payment) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:loan) }

  context '.payment_amount' do
    let(:payment_amount) { Faker::Number.decimal(l_digits: 2).to_f }

    before do
      create_list(:payment, 2, payment_amount: payment_amount)
    end

    it 'gets sum of all payments' do
      all_payments = described_class.payment_amount.to_f
      expect(all_payments).to eq(payment_amount * 2)
    end
  end

  context 'checks check_payment_amount' do
    let(:funded_amount) { Faker::Number.decimal(l_digits: 2).to_f }
    let(:loan) { create(:loan, funded_amount: funded_amount, due_amount: funded_amount) }

    before do
      subject.loan = loan
    end

    it 'checks compares to load due payment' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to include('Payment amount less or equal funded_amount')
    end
  end
end
