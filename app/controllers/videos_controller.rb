class VideosController < ApplicationController
  include TorqueBox::Messaging::Backgroundable
  include Concerns::Transcodable
  always_background :generate_video

  def index
    filter = {}
    filter = {:phrase => params[:transcription]}    if params[:transcription].present?
    filter = filter.merge({:tags => params[:tag].downcase})  if params[:tag].present?
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
    @entry = Entry.new(:copyright => Copyright.new(), transcription: params[:transcription])
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

      head :ok
    else
      response.status = 422
      response_body = { :errors => @entry.errors.full_messages }
      response_body[:errors].concat @entry.copyright.errors.full_messages
      render :json => response_body
    end
  end

  def down_vote

    entry = Entry.get(params[:id])

    entry.ranking = entry.ranking - 1

    respond_to do |format|
      if entry.index

        add_to_session('downvotes', entry.id.to_s)

        format.html { redirect_to :back, :notice => "Video has been successfully down-voted." }
        format.json { render :json => entry }
      else
        format.html { redirect_to :back, :alert => "Video could not been down-voted." }
        format.json { render :json => { :errors => "Video could not been up-voted."}, :status => 422 }
      end
    end
  end

  def up_vote

    entry = Entry.get(params[:id])

    entry.ranking = entry.ranking + 1

    respond_to do |format|
      if entry.index

        add_to_session('upvotes', entry.id.to_s)

        format.html { redirect_to :back, :notice => "Video has been successfully up-voted." }
        format.json { render :json => entry }
      else
        format.html { redirect_to :back, :alert => "Video could not been up-voted." }
        format.json { render :json => { :errors => "Video could not been up-voted."}, :status => 422 }
      end
    end
  end

  private
    
    def add_to_session(domain, value)
      session[domain.to_s] = {} unless session[domain.to_s].present?
      session[domain.to_s] = session[domain.to_s].merge({value.to_s => true})
    end

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
      Rails.logger.warn("------#{entry_id} ---- #{file}")
      VideosController.new.transcode_entry(entry_id, file)
    end
end
