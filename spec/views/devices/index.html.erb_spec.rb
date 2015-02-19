require 'rails_helper'

RSpec.describe "devices/index", type: :view do
  before(:each) do
    assign(:devices, [
      Device.create!(
        :host => "Host",
        :port => 1
      ),
      Device.create!(
        :host => "Host",
        :port => 1
      )
    ])
  end

  it "renders a list of devices" do
    render
    assert_select "tr>td", :text => "Host".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
