module Square
  # https://docs.connect.squareup.com/api/connect/v1/#navsection-fees
  class Fee < APIResource
    extend Square::APIOperations::List
    extend Square::APIOperations::Retrieve
    extend Square::APIOperations::Create
    extend Square::APIOperations::Update
    extend Square::APIOperations::Delete

    endpoint_base 'fees'
    data_type Square::DataTypes::Fee

    # Adjust inventory for a varation.
    #
    # @param item_id [String] Item ID.
    # @param fee_id [String] Fee ID.
    # @param params [Hash] Params hash. Optional.
    #
    # @return [Square::DataType]
    def self.apply(item_id, fee_id, params = {})
      response = Square.make_request(
        method: 'PUT',
        endpoint: "items/#{item_id}/fees/#{fee_id}",
        params: params
      )

      response = Square.parse_response(response)
      Square::DataTypes::Item.new(response)
    end
    
    # Adjust inventory for a varation.
    #
    # @param item_id [String] Item ID.
    # @param fee_id [String] Fee ID.
    # @param params [Hash] Params hash. Optional.
    #
    # @return [Square::DataType]
    def self.remove(item_id, fee_id, params = {})
      response = Square.make_request(
        method: 'DELETE',
        endpoint: "items/#{item_id}/fees/#{fee_id}",
        params: params
      )

      response = Square.parse_response(response)
      Square::DataTypes::Item.new(response)
    end
  end
end
