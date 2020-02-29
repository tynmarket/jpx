require 'spec_helper'

module Jpx
  describe Price do
    describe "self.sq_days" do
      let(:sq_days) { Price.sq_days }

      it { expect(sq_days).to include Date.new(2019, 3, 8) } # SQは第2金曜
    end
  end
end
