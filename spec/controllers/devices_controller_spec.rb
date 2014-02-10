require File.dirname(__FILE__) + '/../spec_helper'

describe DevicesController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "create action should render new template when model is invalid" do
    Device.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Device.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(devices_url)
  end

  it "destroy action should destroy model and redirect to index action" do
    device = Device.first
    delete :destroy, :id => device
    response.should redirect_to(devices_url)
    Device.exists?(device.id).should be_false
  end
end
