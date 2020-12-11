require 'rails_helper'

describe Loan, type: :model do
  subject { build(:loan) }

  it { is_expected.to be_valid }
  it { is_expected.to have_many(:payments) }
  it { is_expected.to validate_presence_of(:funded_amount) }


  context 'funded_vs_due_amounts' do
    let(:loan) { build(:loan,
                       funded_amount: Faker::Number.decimal(l_digits: 2),
                       due_amount:    Faker::Number.decimal(l_digits: 4) ) }

    it 'checks due_amount' do
      expect(loan).not_to be_valid
      expect(loan.errors.full_messages).to include("Due amount less or equal funded amount")
    end
  end

  context '#update_due_amount!' do
    let(:loan) { create(:loan, :with_outstanding_balance) }
    let(:due_amount) { loan.funded_amount - loan.payments.payment_amount }

    before do
      loan.update_column(:due_amount, nil)
    end

    it 'sets due amount to the sum of all payments' do
      expect {
        loan.update_due_amount!
      }.to change(loan, :due_amount).from(nil).to(due_amount)
    end
  end
end
