#
# Yahoo Stock find
# gem ystock
#
# by Greg Winn
# winn.ws
# http://github.com/gregwinn/ystock
#
require 'cgi'
require 'net/http'
class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end

module Ystock
    def ensure_unique(name)
        begin
            self[name] = yield
        end while self.class.exists?(name => self[name])
    end
    
     @@service_uri = "http://download.finance.yahoo.com/d/quotes.csv"
     @@paramset = {
       :ask => 'a',
       :average_daily_volume => 'a2',
       :ask_size => 'a5',
       :bid => 'b',
       :ask_real_time => 'b2',
       :bid_real_time => 'b3',
       :book_value => 'b4',
       :bid_size => 'b6',	 
       :change_with_percent => 'c',
       :change => 'c1',
       :commission => 'c3',
       :change_real_time => 'c6',
       :change_after_hours => 'c8',
       :divident_per_share => 'd',	 
       :last_trade_date => 'd1',
       :trade_date => 'd2',
       :eps => 'e',
       :error_indication => 'e1',
       :eps_estimate_current_year => 'e7',
       :eps_estimate_next_year => 'e8',
       :eps_estimate_next_quarter => 'e9',
       :float_shares => 'f6',
       :days_low => 'g',
       :days_high => 'h',
       :fiftytwo_week_low => 'j',
       :fiftytwo_week_high => 'k',
       :holdings_gain_percent => 'g1',
       :annualized_gain => 'g3',
       :holdings_gain => 'g4',
       :holdings_gain_percent => 'g5',
       :holdings_gain_real_time => 'g6',
       :more_info => 'i',
       :order_book_real_time => 'i5',
       :market_capitalization => 'j1',
       :market_cap => 'j3',
       :EBITDA => 'j4',
       :change_from_52wk_low => 'j5',
       :percent_change_from_52wk_low => 'j6',
       :last_trade_real_time_with_time => 'k1',
       :change_percent_real_time => 'k2',
       :last_trade_size => 'k3',
       :change_from_52wk_high => 'k4',
       :percent_change_from_52wk_high => 'k5',
       :last_trade_with_time => 'l',
       :price => 'l1',
       :high_limit => 'l2',
       :low_limit => 'l3',
       :days_range => 'm',
       :days_range_real_time => 'm2',
       :fifty_day_moving_average => 'm3',
       :twohundred_day_moving_average => 'm4',
       :change_from_200_day_moving_average => 'm5',
       :percent_change_from_200_day_moving_average => 'm6',
       :change_from_50_day_moving_average => 'm7',
       :percent_change_from_50_day_moving_average => 'm8',
       :name => 'n',
       :notes => 'n4',
       :open => 'o',
       :previous_close => 'p',
       :price_paid => 'p1',
       :change_in_percent => 'p2',
       :price_sales => 'p5',
       :price_book => 'p6',
       :ex_dividend_date => 'q',
       :p_e_ratio => 'r',
       :dividend_pay_date => 'r1',
       :p_e_ratio_real_time => 'r2',
       :peg_ratio => 'r5',
       :price_eps_estimate_current_year => 'r6',
       :price_eps_estimate_next_year => 'r7',
       :symbol => 's',
       :shared_owned => 's1',
       :short_ratio => 's7',
       :last_trade_time => 't1',
       :trade_links => 't6',
       :ticker_trend => 't7',
       :one_year_target_price => 't8',
       :volume => 'v',
       :holdings_value => 'v1',
       :holdings_value_real_time => 'v7',
       :fifty_two_week_range => 'w',
       :days_value_change => 'w1',
       :days_value_change_real_time => 'w4',
       :stock_exchange => 'x',
       :dividend_yield => 'y'
     }
     # Ystock.find(['stock', 'stock'])
     def self.find(args)
         output = Array.new
         args.each do |stock|
             s = send_request(stock.to_s)
             a = s.chomp.split(",")
             h = {:symbol => stock.to_s}
             @@paramset.values.each_with_index{|v,i| 
             h[@@paramset.invert[v]] = a[i]
            }
            output << h
         end
         return output
     end
     
    def self.get_stock(stock)
        output = Array.new
        s = send_request(stock)
        a = s.chomp.split(",")
        h = {:symbol => stock.to_s}
            @@paramset.values.each_with_index{|v,i| 
             h[@@paramset.invert[v]] = a[i]
            }
            output = h
       return output
    end

    def self.send_request(*args)
        completed_path = @@service_uri + construct_args(*args)
        uri = URI.parse(completed_path)
        response = Net::HTTP.start(uri.host, uri.port) do |http|
            http.get completed_path
        end
        return response.body
     end

     def self.construct_args(*args)
        path = "?f=#{@@paramset.values.join}&s=" + args.map{|x| CGI.escape(x)}.join(",")
     end
    
end
