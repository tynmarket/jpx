require 'spec_helper'

module Jpx
  describe Price do
    describe "parse" do
      let(:file) do
        Tempfile.open("temp") do |f|
          f.puts "header"
          f.puts data
          f.puts
          f
        end
      end
      let(:price) { Price.parse(file.path)[0] }

      before { file.open }

      context "寄り付き" do
        let(:data) { "20180104,18,163030018,999,0845,23100,23100,23080,23080,3027,23098.1169,125,10845,201803" }

        it { expect(price[:datetime]).to eq Time.new(2018, 1, 4, 8, 45) }
      end

      context "大引け" do
        let(:data) { "20180104,18,163030018,999,1515,23410,23410,23410,23410,3709,23410,3,11515,201803" }

        it { expect(price[:datetime]).to eq Time.new(2018, 1, 4, 15, 10) }
      end

      context "大納会後の16:30" do
        let(:data) { "20180104,18,163030018,003,1630,22760,22760,22760,22760,189,22760,5,01630,201803" }

        it { expect(price[:datetime]).to eq Time.new(2017, 12, 29, 16, 30) }
      end

      context "大納会翌日の05:30" do |variable|
        let(:data) { "20180104,18,163030018,003,0530,22780,22780,22780,22780,107,22780,1,10530,201803" }

        it { expect(price[:datetime]).to eq Time.new(2017, 12, 30, 5, 30) }
      end

      context "期先" do
        let(:data) { "20180104,18,163060018,999,0845,22930,22930,22930,22930,48,22930,2,10845,201806" }

        it { expect(price).to eq nil }
      end
    end

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
