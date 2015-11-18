require 'spec_helper'

describe Square::APIResource do
  describe '.data_type' do
    it 'should should assign the data_type class variable' do
      class Test < Square::APIResource
        data_type 'type'

        def self.get_type
          @data_type
        end
      end

      expect(Test.get_type).to eq 'type'
    end
  end

  describe '.endpoint_base' do
    it 'should should assign the endpoint_base class variable' do
      class Test < Square::APIResource
        endpoint_base 'endpoint'

        def self.get_endpoint_base
          @endpoint_base
        end
      end

      expect(Test.get_endpoint_base).to eq 'endpoint'
    end
  end

  describe '.nested_under' do
    it 'should should assign the class variable' do
      class Test < Square::APIResource
        nested_under 'resource'

        def self.get_nested_under
          @nested_under
        end
      end

      expect(Test.get_nested_under).to eq 'resource'
    end
  end

  describe '.generate_endpoint_url' do
    it 'should generate the correct URL for a resource' do
      class Resource < Square::APIResource
        endpoint_base 'resource'
      end

      class NestedResource < Square::APIResource
        endpoint_base 'nested-resource'
        nested_under 'resource'
      end

      expect(Resource.generate_endpoint_url('a', 'b', 'c', 'd'))
        .to eq 'b/resource/a'

      expect(NestedResource.generate_endpoint_url('a', 'b', 'c', 'd'))
        .to eq 'resource/b/nested-resource/a'
    end
  end
end
