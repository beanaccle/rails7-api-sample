require 'rails_helper'

RSpec.describe Users::PointPayment do
  describe "#call" do
    let(:buyer) { create(:user, email: "buyer@example.com", points: 100_000) }
    let(:seller) { create(:user, email: "seller@example.com") }

    context "when buyer has enough points" do
      it "buyer points decreased" do
        expect {
          described_class.new(buyer).call(seller, 1_000)
        }.to change(buyer, :points).by(-1_000)
      end

      it "seller points increased" do
        expect {
          described_class.new(buyer).call(seller, 1_000)
        }.to change(seller, :points).by(1_000)
      end

      context "when failed to save seller" do
        it "buyer points not change" do
          allow(seller).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

          expect {
            described_class.new(buyer).call(seller, 1_000)
          }.to raise_error(ActiveRecord::RecordInvalid)

          expect(buyer.reload.points).to eq(100_000)
        end
      end
    end

    context "when buyer has not enough points" do
      it "raise Users::NotEnoughPointsError" do
        expect {
          described_class.new(buyer).call(seller, 100_000_000)
        }.to raise_error(Users::NotEnoughPointsError)
      end
    end
  end
end
