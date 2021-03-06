require 'spec_helper'
require 'messages/apps/app_feature_update_message'

module VCAP::CloudController
  RSpec.describe AppFeatureUpdateMessage do
    let(:body) do
      {
        'enabled' => true,
      }
    end

    describe '.create_from_http_request' do
      it 'returns the correct AppFeatureUpdateMessage' do
        message = AppFeatureUpdateMessage.create_from_http_request(body)

        expect(message).to be_a(AppFeatureUpdateMessage)
        expect(message.enabled).to eq(true)
      end
    end

    describe 'validations' do
      it 'validates that there are not excess fields' do
        body['bogus'] = 'field'
        message = AppFeatureUpdateMessage.create_from_http_request(body)

        expect(message).to_not be_valid
        expect(message.errors.full_messages).to include("Unknown field(s): 'bogus'")
      end

      describe 'enabled' do
        it 'allows true' do
          body = { enabled: true }
          message = AppFeatureUpdateMessage.create_from_http_request(body)

          expect(message).to be_valid
        end

        it 'allows false' do
          body = { enabled: false }
          message = AppFeatureUpdateMessage.create_from_http_request(body)

          expect(message).to be_valid
        end

        it 'validates that it is a boolean' do
          body = { enabled: 1 }
          message = AppFeatureUpdateMessage.create_from_http_request(body)

          expect(message).to_not be_valid
          expect(message.errors.full_messages).to include('Enabled must be a boolean')
        end

        it 'must be present' do
          body = {}
          message = AppFeatureUpdateMessage.create_from_http_request(body)
          expect(message).to_not be_valid
          expect(message.errors.full_messages).to include('Enabled must be a boolean')
        end
      end
    end
  end
end
