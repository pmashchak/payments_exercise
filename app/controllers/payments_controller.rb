class PaymentsController < ApplicationController
  include LoansHelper

  def index
    render json: loan.payments
  end

  def show
    render json: payment
  end

  def create
    payment = loan.payments.new(payment_params)

    if payment.save
      render json: payment
    else
      render json: payment.errors.full_messages, status: :bad_request
    end
  end

  private

  def payment
    @payment ||= Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:payment_amount)
  end
end
