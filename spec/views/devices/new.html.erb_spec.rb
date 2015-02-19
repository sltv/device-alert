require 'rails_helper'

RSpec.describe "devices/new", type: :view do
  before(:each) do
    assign(:device, Device.new(
      :host => "MyString",
      :port => 1
    ))
  end

  it "renders new device form" do
    render

    assert_select "form[action=?][method=?]", devices_path, "post" do

      assert_select "input#device_host[name=?]", "device[host]"

      assert_select "input#device_port[name=?]", "device[port]"
    end
  end
end
