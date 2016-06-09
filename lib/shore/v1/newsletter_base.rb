require_relative 'client_base'

module Shore
  module V1
    # @abstract
    class NewsletterBase < ClientBase
      self.site = url_for(:newsletter, :v1)
    end
  end
end
