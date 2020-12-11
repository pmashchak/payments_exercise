class LoansController < ApplicationController
  include LoansHelper

  def index
    render json: Loan.all
  end

  def show
    render json: loan
  end
end
