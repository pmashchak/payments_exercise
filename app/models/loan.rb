class Loan < ActiveRecord::Base
  has_many :payments

  validates :funded_amount, presence: true
  validate  :funded_vs_due_amounts

  def update_due_amount!
    update_attributes(due_amount: funded_amount - payments.payment_amount)
  end

  private

  def funded_vs_due_amounts
    return if due_amount.blank? || funded_amount.blank?
    if due_amount > funded_amount
      errors.add :due_amount, 'less or equal funded amount'
    end
  end
end
