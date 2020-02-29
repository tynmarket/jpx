require 'spec_helper'

module Jpx
  describe Price do
    describe "self.near_term?" do
      let(:near_term) { Price.near_term?(time, contract_month) }
      context "SQ前日の引け" do
        let(:time) { Time.parse "201803081510" }

        context "期近" do
          let(:contract_month) { "201803" }

          it { expect(near_term).to eq true }
        end

        context "期先" do
          let(:contract_month) { "201806" }

          it { expect(near_term).to eq false }
        end
      end

      context "SQ前日の夕場寄り付き" do
        let(:time) { Time.parse "201803091630" }
        let(:contract_month) { "201806" }

        context "期近" do
          let(:contract_month) { "201806" }

          it { expect(near_term).to eq true }
        end

        context "期先" do
          let(:contract_month) { "201809" }

          it { expect(near_term).to eq false }
        end
      end

      context "SQ当日の夕場引け" do
        let(:time) { Time.parse "201803090530" }

        context "期近" do
          let(:contract_month) { "201806" }

          it { expect(near_term).to eq true }
        end

        context "期先" do
          let(:contract_month) { "201809" }

          it { expect(near_term).to eq false }
        end
      end

      context "SQ当日の寄り付き" do
        let(:time) { Time.parse "201803090845" }
        let(:contract_month) { "201806" }

        context "期近" do
          let(:contract_month) { "201806" }

          it { expect(near_term).to eq true }
        end

        context "期先" do
          let(:contract_month) { "201809" }

          it { expect(near_term).to eq false }
        end
      end
    end

    describe "self.sq_dates" do
      let(:sq_dates) { Price.sq_dates }

      it { expect(sq_dates).to include Date.new(2019, 3, 8) } # SQは第2金曜
    end
  end
end
