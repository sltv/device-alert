require 'rails_helper'

RSpec.describe "devices/edit", type: :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      :host => "MyString",
      :port => 1
    ))
  end

  it "renders the edit device form" do
    render

    assert_select "form[action=?][method=?]", device_path(@device), "post" do

      assert_select "input#device_host[name=?]", "device[host]"

      assert_select "input#device_port[name=?]", "device[port]"
    end
  end
end
