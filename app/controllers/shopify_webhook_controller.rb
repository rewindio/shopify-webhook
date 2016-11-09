class ShopifyWebhookController < ApplicationController
  require 'openssl'
  require 'ostruct'

  protect_from_forgery except: :perform

  def perform
    body = JSON.parse(request.body.read)
    #the Shopify domain is now available via body.delete('X-Shopify-Shop-Domain')
    shop = body.delete('X-Shopify-Shop-Domain')

    webhook = body.delete('X-Shopify-Topic').gsub! '/', '_'

    data = JSON.parse(Base64.strict_decode64(body.delete('body')).force_encoding('UTF-8'))

    begin
      #this assumes that shop is a ShopifyAPI::Shop
      shop.with_shopify_session { self.send webhook, data, shop }

    rescue => e
      render nothing: true, status: :unprocessable_entity
      return
    end

    render nothing: true, status: :ok
  end

  private

  def app_uninstalled(data, shop)
  end

  def collections_create(data, shop)
  end

  def collections_update(data, shop)
  end

  def collections_delete(data, shop)
  end

  def checkouts_create(data, shop)
  end

  def checkouts_update(data, shop)
  end

  def checkouts_delete(data, shop)
  end

  def customers_create(data, shop)
  end

  def customers_update(data, shop)
  end

  def customers_delete(data, shop)
  end

  def orders_create(data, shop)
  end

  def orders_updated(data, shop)
  end

  def orders_delete(data, shop)
  end

  def products_create(data, shop)
  end

  def products_update(data, shop)
  end

  def products_delete(data, shop)
  end

  def shop_update(data, shop)
  end
end