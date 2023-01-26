# frozen_string_literal: true

module Integrations
  class ProductsController < ::ApiController
    def create
      product_params.each do |product|
        new_product = ::Product.find_or_initialize_by({ code: product['code'] })

        new_product.name = product['name']
        new_product.active = true
        new_product.created_by_id = @current_user.id
        new_product.account_id = @current_user.account_id

        product['product_derivations'].each do |product_derivation|
          new_product_derivation = new_product.product_derivations.find_or_initialize_by({
                                                                                           code: product_derivation['code'],
                                                                                           account_id: @current_user.account_id
                                                                                         })
          new_product_derivation.multiple_quantity = product_derivation['multiple_quantity']
          new_product_derivation.save!

        end if product['product_derivations'].any?

        attach_files(new_product: new_product, product: product)

        new_product.save!
      end
      render json: product_params.pluck(:code).join(',')
    end

    private

    def product_params
      params.require(:products)
    end

    def attach_files(new_product: nil, product: nil)
      return unless product

      Rails.logger.info "Produto: #{product['code']}"

      unless product['file_url'].blank?
        uri = URI.parse((product['file_url']).to_s)
        danfe = URI.open(uri.to_s, { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE })
        File.open("tmp/#{product['code']}.pdf", 'wb') { |f| f.write(danfe.read) }
        new_product&.file&.attach(io: File.open("tmp/#{product['code']}.pdf"), filename: "#{product['code']}.pdf")
      end
    end
  end
end
