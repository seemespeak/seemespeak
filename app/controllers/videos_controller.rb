class VideosController < ApplicationController
  include TorqueBox::Messaging::Backgroundable

  def index
    @entries = Entry.search(:phrase => params[:transcription])
  end

  def new
    @entry = Entry.new
  end

  def create
    file = params[:entry].delete(:video)
    @entry = Entry.new(params[:entry])
    @entry.video = Video.new
    @entry.index

    write_video(@entry, file)

    redirect_to videos_path
  end

  private
    def temp_path
      VideoConversionSettings.temp_path
    end

    def temp_file_path(entry)
      File.join(temp_path, entry.id + ".webm")
    end

    def write_video(entry, file)
      File.open(temp_file_path(entry), "wb") { |f| f.write(file.read) }
    end
end
