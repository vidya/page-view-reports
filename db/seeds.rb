# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#
# | id (integer) | url (varchar)     | referrer (null varchar)   | created_at (datetime)     | hash (varchar)                   |
# | :----------- | :---------------- | :------------------------ | :------------------------ | :------------------------------- |
# | 1            | http://apple.com  | http://store.apple.com/us | 2012-01-01T00:00:00+00:00 | abe81c0456367aff8132c24d04718878 |
# | 2            | https://apple.com | null                      | 2013-01-20T08:21:10+00:00 | f4a33acf2af3e2118038749588998512 |

class PageViewsCreate
  attr_accessor :row_id

  def initialize()
    @row_id = 0
  end

  def add_page_views

    block_size      = 1000
    blocks_needed   = 1000

    (1..blocks_needed).each do |block_num|
      row_block = []
      block_size.times { row_block << get_next_row }

      PageView.db.transaction { PageView.multi_insert row_block }

      puts "page views created: #{block_num * block_size}"
    end
  end

  def read_page_views
    PageView.dataset.each{|r| p r}
  end

  private
  def get_random_url

    [
      'http://apple.com',
      'https://apple.com',
      'https://www.apple.com',

      'http://developer.apple.com',
      'http://en.wikipedia.org',
      'http://opensource.org',

      'http://maps.apple.com/',
      'http://www.opensource.apple.com/',
      'http://scap-on-apple.macosforge.org/',

      'https://discussions.apple.com/',
      'http://www.macrumors.com/',
      'http://investor.apple.com/',

      'http://www.appleenthusiast.com/',
      'http://www.macworld.com/',
      'http://apple.slashdot.org/',
    ].sample
  end

  def get_random_referrer
    [
      'http://apple.com',
      'https://apple.com',
      'https://www.apple.com',

      'http://developer.apple.com',
      nil,

      'http://maps.apple.com/',
      'http://www.opensource.apple.com/',
      'http://scap-on-apple.macosforge.org/',

      'https://discussions.apple.com/',
      'http://www.macrumors.com/',
      'http://investor.apple.com/',

      'http://www.appleenthusiast.com/',
      'http://www.macworld.com/',
      'http://apple.slashdot.org/',
    ].sample
  end

  def get_random_time
    now = Time.now
    ten_days_ago = now - 10 * (60 * 60 * 24)

    rand(ten_days_ago..now)
  end

  def get_row_hash(row)

    @row_id = @row_id + 1

    if row[:referrer].nil?
      row_hash = Digest::MD5.hexdigest({ id: @row_id, url: row[:url],
                                       created_at: row[:created_at] }.to_s)
    else
      row_hash = Digest::MD5.hexdigest({ id: @row_id, url: row[:url], referrer: row[:referrer],
                                       created_at: row[:created_at] }.to_s)
    end
  end

  def get_next_row

    row               = {}

    row[:created_at]  = get_random_time
    row[:url]         = get_random_url
    row[:referrer]    = get_random_referrer
    row[:hash]        = get_row_hash(row)

    row
  end
end

#--- main()
#
PageViewsCreate.new.add_page_views
