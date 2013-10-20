class VideosController < ApplicationController
  include TorqueBox::Messaging::Backgroundable
  include Concerns::Transcodable
  always_background :generate_video

  def index
    filter = {}
    filter = {:phrase => params[:transcription]}    if params[:transcription].present?
    filter = filter.merge({:tags => params[:tag]})  if params[:tag].present?
    filter = filter.merge({:from => params[:from]}) if params[:from].present?
    filter = filter.merge({:random => Integer(params[:random])})  if params[:random].present?
    filter = filter.merge({:size => 9})

    if params["old_reviewed"].nil? || params["reviewed"] == "1" || (params["old_reviewed"] == 1 && params["reviewed"].nil?)
      params["reviewed"] = 1
    else
      params["reviewed"] = 0
    end

    filter[:reviewed] = params["reviewed"] == 1

    flags = Entry::ALLOWED_FLAGS.clone
    Entry::ALLOWED_FLAGS.each do |flag|
      flags.delete(flag) if params[flag] == "1"
    end
    filter["ignored_flags"] = flags unless flags.empty?
    @entries = Entry.search(filter)
  end

  def new
    @entry = Entry.new(:copyright => Copyright.new())
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

    if [@entry.valid?, @entry.copyright.valid?].all?
      write_video(@entry, file)

      VideosController.generate_video(@entry.id, file.path)

      redirect_to videos_path
    else
      response.status = 422
      response_body = { :errors => @entry.errors.full_messages }
      response_body[:errors].concat @entry.copyright.errors.full_messages
      render :json => response_body
    end
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
