module LoansHelper
  extend ActiveSupport::Concern

  def loan
    @loan ||= Loan.find(loan_id)
  end

  private

  def loan_id
    params[:loan_id].presence || params[:id].presence
  end
end
