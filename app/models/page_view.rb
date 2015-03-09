
class PageView < Sequel::Model(:page_views)

  # ### Report #1
  #
  # The end-user should be able to access a REST endpoint in your application in order to retrieve
  # the number of page views per URL, grouped by day, for the past 5 days.
  #
  # Example request:
  #
  # 	[GET] /top_urls
  #
  # Payload
  # > { '2012-01-01' : [ { 'url': 'http://apple.com', 'visits': 100 } ] }
  #

  def self.top_urls

    top_urls_hash = {}

    day_num = Date.today

    5.times do
      day_num -= 1

      top_urls_hash[day_num.strftime] = filter("created_at >= ? and created_at < ?", day_num, day_num + 1).

                                            group_and_count(:url).
                                            order_by(Sequel.desc(:count)).

                                            map do |dest|
                                              {
                                                :url      => dest.url,
                                                :visits   => dest.values[:count]
                                              }
                                            end
    end

    top_urls_hash
  end

  # # Report #2
  #
  # Your end-users should be able to retrieve the top 5 referrers for the top 10 URLs grouped by day, for the past 5 days, via a REST endpoint.
  #
  # Example request:
  #
  # 	[GET] /top_referrers
  #
  # Payload
  # > {
  # >	'2012-01-01' : [
  # >		{
  # >			'url': 'http://apple.com',
  # >			'visits': 100,
  # >			'referrers': [ { 'url': 'http://store.apple.com/us', 'visits': 10 } ]
  # >		}
  # >	]
  #

  def self.top_referrers

    #-- init the output hash of this method
    #
    top_referrers_hash = {}

    day_num = Date.today

    5.times do
      day_num -= 1

      reference_rec = {}

      filter("created_at >= ? and created_at < ?", day_num, day_num + 1).

        group_and_count(:url, :referrer).
        order_by(Sequel.desc(:count)).

        each do |dest|
          reference_rec[dest.url] = [] unless reference_rec.has_key?(dest.url)

          reference_rec[dest.url] << {
                                        :url        => dest.referrer,
                                        :visits     => dest.values[:count]
                                     }
        end

      #-- count the total number of references for each url
      #--
      reference_total = {}
      reference_rec.keys.each do |dest_url|
        reference_total[dest_url] = 0 unless reference_total.has_key?(dest_url)

        #-- get the array of { :referring_url => ..., :visits => ... }
        #   for the dest_url
        #
        reference_counts = reference_rec[dest_url]

        #-- sum up the reference_counts; remember to ignore 'null' referring_url's
        #--
        reference_counts.each do |ref_rec|
          reference_total[dest_url] += ref_rec[:visits] unless ref_rec[:url].nil?
        end
      end

      #-- choose the top ten most popular destination url's
      #--
      popular_top_ten = reference_total.keys.
                            sort_by { |dest_url| reference_total[dest_url] }.
                            reverse.
                            slice(0, 10)

      #-- store info about the top 5 reference sources for each of the ten most popular destination url's
      #
      top_5_sources = {}
      popular_top_ten.each do |dest|
        top_5_sources[dest] = reference_rec[dest].
                                reject  { |uv_hash| uv_hash[:url].nil? }.
                                sort_by { |uv_hash| uv_hash[:visits] }.
                                reverse.
                                slice(0, 5)
      end

      #-- make the entry for this day in the output hash
      #--
      # top_referrers_hash[day_start.strftime] = popular_top_ten.map do |dest|
      top_referrers_hash[day_num.strftime] = popular_top_ten.map do |dest|
        {
          :url          => dest,
          :visits       => reference_total[dest],
          :referrers    => top_5_sources[dest]
        }
      end
    end

    top_referrers_hash
  end

end
