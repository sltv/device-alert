require 'rails_helper'

RSpec.describe "devices/show", type: :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      :host => "Host",
      :port => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Host/)
    expect(rendered).to match(/1/)
  end
end
