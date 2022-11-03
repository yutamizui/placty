class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
    if current_user.present?
      @notes = Note.where(user_id: current_user.id)
    else
      redirect_to root_path, alert:"ユーザー登録、ログインをしてください"
    end
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      redirect_to note_path(@note)
      UserActionMailer.note_creation_notifier(@note).deliver
    else
      flash.now[:alert] = t('activerecord.attirbutes.activity.failed_to_create')
      render 'new'
    end
  end
  

  def update
    if @note.update(note_params)
      redirect_to note_path(id: @note), notice: t('activerecord.attributes.notification.updated')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'notes/edit' 
    end
  end

  def duplicate
    @note = Note.find(params[:id])
    @duplicated_note = Note.create(
      title: params[:note_title],
      content: @note.content,
      user_id: params[:user_id]
    )
    redirect_to note_path(id: @duplicated_note.id), notice: "ノートをコピーしました！"
    return
  end
  
  def destroy
    @note.destroy
    redirect_to note_path(id: current_user.notes.first.id), notice: "ノートを削除しました。"
  end


  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content, :user_id)
  end

end
