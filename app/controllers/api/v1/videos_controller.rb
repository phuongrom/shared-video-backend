module Api
  module V1
    class VideosController < ApplicationController
      include JwtAuthenticatable
      include Pagy::Backend

      skip_before_action :authenticate_user!, only: [:index]

      def index
        @pagy, videos = pagy(Video.includes(:user).order(created_at: :desc))
        render json: {
          videos: videos.map { |v| video_json(v) },
          pagination: pagy_metadata(@pagy)
        }
      end

      def create
        youtube_id = YoutubeHelper.extract_id(params[:url])
        return render json: { error: "Invalid YouTube URL" }, status: :unprocessable_entity unless youtube_id

        # Fetch metadata from noembed (free, no API key needed)
        metadata = YoutubeHelper.fetch_metadata(params[:url])
        return render json: { error: "Could not fetch video info" }, status: :unprocessable_entity unless metadata

        video = current_user.videos.new(
          url: params[:url],
          youtube_id: youtube_id,
          title: metadata[:title],
          thumbnail_url: metadata[:thumbnail_url],
          description: metadata[:description]
        )

        if video.save
          render json: { video: video_json(video) }, status: :created
        else
          render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def video_json(video)
        {
          id: video.id,
          title: video.title,
          youtube_id: video.youtube_id,
          url: video.url,
          thumbnail_url: video.thumbnail_url,
          description: video.description,
          shared_by: { id: video.user.id, name: video.user.name, email: video.user.email },
          created_at: video.created_at.iso8601
        }
      end
    end
  end
end
