# Utility for YouTube URL parsing and metadata fetching via noembed.com
module YoutubeHelper
  YOUTUBE_REGEX = /
    (?:https?:\/\/)?
    (?:www\.)?
    (?:youtube\.com\/(?:watch\?v=|embed\/|v\/)|youtu\.be\/)
    ([a-zA-Z0-9_-]{11})
  /x

  NOEMBED_URL = "https://noembed.com/embed"

  def self.extract_id(url)
    return nil if url.blank?
    match = url.match(YOUTUBE_REGEX)
    match ? match[1] : nil
  end

  def self.fetch_metadata(url)
    response = HTTParty.get(NOEMBED_URL, query: { url: url }, timeout: 10)
    return nil unless response.success?

    # noembed returns text/javascript so HTTParty won't auto-parse — do it manually
    data = JSON.parse(response.body)
    return nil if data["error"].present?

    {
      title: data["title"],
      thumbnail_url: data["thumbnail_url"],
      description: data["author_name"] ? "Shared from YouTube" : nil
    }
  rescue HTTParty::Error, Net::OpenTimeout, SocketError => e
    Rails.logger.error("YoutubeHelper fetch error: #{e.message}")
    nil
  end
end
