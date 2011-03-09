require 'active_support'
require 'digest/sha2'

class FacebookDecoder

  def self.decode data
    unless data.nil?
      sig, b64udata = data.split('.')
      unless b64udata.nil?
        json = b64udata.tr('-_', '+/').unpack('m')[0]
        begin
          parms = JSON.parse(json)
        rescue => e
          begin
            parms = JSON.parse(json + '"}')
          rescue => e2
            begin
              parms = JSON.parse(json + '}')
            rescue => e3
              raise "Unable to parse json structure - '#{json}'"
              parms = {}
            end
          end
        end
      end
    end
    parms
  end

end
