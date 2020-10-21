FactoryBot.define do
  factory :payment do
    amount { Faker::Number.decimal(l_digits: 2) }
    date { Faker::Time.between(from: 1.month.ago, to: DateTime.now) }
  end
end

# == Schema Information
#
# Table name: payments
#
#  id                  :bigint           not null, primary key
#  amount              :decimal(, )
#  date                :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  billing_contract_id :bigint
#
# Indexes
#
#  index_payments_on_billing_contract_id  (billing_contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (billing_contract_id => billing_contracts.id)
#