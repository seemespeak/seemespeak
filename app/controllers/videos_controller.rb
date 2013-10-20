class VideosController < ApplicationController
  include TorqueBox::Messaging::Backgroundable
  include Concerns::Transcodable
  always_background :generate_video

  def index
    @entries = Entry.search(:phrase => params[:transcription])
  end

  def new
    @entry = Entry.new
  end

  def show
    @entry = Entry.get(params[:id])

    respond_to do |format|
      format.html { render action: "show" }
      format.js   { render "show.html.js" }
    end
  end

  def create
    file = params[:entry].delete(:video)
    @entry = Entry.new(params[:entry])
    @entry.video = Video.new
    @entry.index

    write_video(@entry, file)

    VideosController.generate_video(@entry.id, file.path)

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

    def self.generate_video(entry_id, file)
      VideosController.new.transcode_entry(entry_id, file)
    end
end
