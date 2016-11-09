EmbededApp::Application.routes.draw do
  post '' => 'shopify_webhook#perform'
end
