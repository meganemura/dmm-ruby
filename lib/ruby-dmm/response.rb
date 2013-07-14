# encoding: utf-8
require 'ruby-dmm/response/item'

module DMM
  class Response
    attr_reader :request, :result

    def initialize(response)
      @request = response[:request][:parameters][:parameter].inject({}) {|hash, params| hash.merge(params[:name].to_sym => params[:value]) }
      if response[:result][:message] && response[:result][:errors]
        @result  = response[:result]
      else
        @result  = DMM::Response::Result.new(response[:result])
      end
    end

    class Result
      RESULT_KEYS = [:result_count, :total_count, :first_position, :items]
      attr_reader *RESULT_KEYS

      def initialize(result)
        (RESULT_KEYS - [:items]).each do |key|
          instance_variable_set("@#{key}", result[key].to_i)
        end

        @items = [result[:items][:item]].flatten.map do |item|
          DMM::Response::Item.new(item)
        end
      end
    end
  end
end
