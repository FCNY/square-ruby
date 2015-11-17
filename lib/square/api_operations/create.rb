module Square
  module APIOperations
    module Create
      # Create resource.
      #
      # @param parent_id [String] ID of the 'parent' to update. Optional.
      # @param params [Hash] Payload. Optional.
      #
      # @return [DataType]
      def create(*args, params)
        parent_id = args

        request = {
          method: 'POST',
          endpoint: self.generate_endpoint_url(nil, parent_id),
          payload: params
        }

        response = Square.make_request(request)
        response = JSON.parse(response)
        @data_type.new(response)
      end
    end
  end
end
