class NoticeBoardsController < ApplicationController
  before_action :find_notice_board, only: [:show, :edit, :update, :destroy]

  def index
    @notice_boards = NoticeBoard.all.order(created_at: :DESC)
  end

  def new
    @notice_board = NoticeBoard.new
  end

  def create
    @notice_board = NoticeBoard.new(notice_board_params)
    if @notice_board.save
      redirect_to notice_boards_path, notice: t('activerecord.attributes.notification.requested')
    else
      flash.now[:alert] = t('activerecord.attributes.activity.failed_to_create')
      render 'new'
    end
  end

  def edit
  end

  def update
    if @notice_board.update(notice_board_params)
      redirect_to notice_boards_path, notice: t('activerecord.attributes.notification.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'notice_boards/edit'
    end
  end

  def destroy
    @notice_board.destroy
    redirect_to notice_boards_path, notice: t('activerecord.attributes.notification.deleted')
  end

  def find_notice_board
    @notice_board = NoticeBoard.find(params[:id])
  end

  def notice_board_params
    params.require(:notice_board).permit(:note, :user_id, :language_id)
  end

end
