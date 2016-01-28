shared_context 'a index request' do |options|
  describe "GET #{options[:path]}" do
    before { get :index, defined?(params) ? params : nil }

    let(:resource) { described_class.to_s.gsub('Controller', '').downcase }

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to render_with_layout 'admin' }
    it { is_expected.to respond_with :success }
    it { expect(controller.instance_variables).to include(:"@#{resource}") }
  end
end

shared_context 'a new request' do |options|
  describe "GET #{options[:path]}" do
    before { get :new, defined?(params) ? params : nil }

    let(:resource) do
      described_class.to_s.gsub('Controller', '').singularize.downcase
    end

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to render_with_layout 'admin' }
    it { is_expected.to respond_with :success }
    it { expect(controller.instance_variables).to include(:"@#{resource}") }
  end
end

shared_context 'a create request' do |options|
  describe "POST #{options[:path]}" do
    let(:resource) do
      described_class.to_s.gsub('Controller', '').singularize.downcase.to_sym
    end

    let(:redirect_to_path) { send("#{resource.to_s.pluralize}_path") }

    before { post :create, resource => params }

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to redirect_to_path }
    it { is_expected.to set_flash[:notice] }
    it { expect(controller.instance_variables).to include(:"@#{resource}") }
    it do
      is_expected.to permit(*permitted_params)
        .for(:create, params: { resource => params })
        .on(resource)
    end
  end
end

shared_context 'an edit request' do |options|
  describe "GET #{options[:path]}" do
    let(:resource) do
      described_class.to_s.gsub('Controller', '').singularize.downcase.to_sym
    end

    before { get :edit, defined?(params) ? params : nil }

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to render_with_layout 'admin' }
    it { is_expected.to respond_with :success }
    it { expect(controller.instance_variables).to include(:"@#{resource}") }
  end
end

shared_context 'an update request' do |options|
  describe "PATCH #{options[:path]}" do
    let(:resource) do
      described_class.to_s.gsub('Controller', '').singularize.downcase.to_sym
    end

    before { patch :update, defined?(params) ? params : nil }

    let(:redirect_to_path) { send("#{resource.to_s.pluralize}_path") }

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to redirect_to_path }
    it { is_expected.to set_flash[:notice] }
    it do
      is_expected.to permit(*permitted_params)
        .for(:update, params: params)
        .on(resource)
    end
  end
end

shared_context 'a destroy request' do |options|
  describe "DELETE #{options[:path]}" do
    let(:resource) do
      described_class.to_s.gsub('Controller', '').singularize.downcase.to_sym
    end

    before { delete :destroy, defined?(params) ? params : nil }

    let(:redirect_to_path) { send("#{resource.to_s.pluralize}_path") }

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to redirect_to_path }
    it { is_expected.to set_flash[:notice] }
  end
end
