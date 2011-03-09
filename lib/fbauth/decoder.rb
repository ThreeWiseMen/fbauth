require 'active_support'
require 'digest/sha2'

class FacebookDecoder

  def self.decode data
    unless data.nil?
      sig, b64udata = data.split('.')
      unless b64udata.nil?
        json = b64udata.tr('-_', '+/').unpack('m')[0]
        begin
          parms = JSON.parse(balance(json))
        rescue => e
          raise "Unable to parse json structure - '#{json}'"
        end
      end
    end
    parms
  end

  def self.balance input
    input += '"' * (input.count('"') % 2)
    input += "}" * (input.count('{') - input.count('}'))
  end
end
