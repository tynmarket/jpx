require 'spec_helper'

module Jpx
  describe Price do
    describe "self.sq_dates" do
      let(:sq_dates) { Price.sq_dates }

      it { expect(sq_dates).to include Date.new(2019, 3, 8) } # SQは第2金曜
    end
  end
end
