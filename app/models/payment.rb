class Payment < ActiveRecord::Base
  delegate :due_amount, :funded_amount, to: :loan

  after_save { loan.update_due_amount! }

  belongs_to :loan

  validates :loan, :payment_amount, presence: true
  validate :check_payment_amount

  scope :payment_amount, -> () { sum(:payment_amount) }

  private

  def check_payment_amount
    return if loan.nil? || due_amount.nil?
    if due_amount + payment_amount > funded_amount
      errors.add(:payment_amount, 'less or equal funded_amount')
    end
  end
end
