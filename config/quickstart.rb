require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

APPLICATION_NAME = 'TEST_ACCOUNT'
MY_CALENDAR_ID = '操作したいカレンダーのID'
CLIENT_SECRET_PATH = 'JSONファイルのパス'
TIME_ZONE = 'Japan'

class Calendar
  def initialize
    # カレンダー操作用のインスタンスを生成、@serviceとして投入
    @service = Google::Apis::CalendarV3::CalendarService.new
    # オプションとしてアプリケーションの名前を設定（ここではサービスアカウント名）
    @service.client_options.application_name = APPLICATION_NAME
    # 認証を行う
    @service.authorization = authorize
    # 利用するカレンダーのIDを設定する
    @calendar_id = MY_CALENDAR_ID
  end

  def authorize
    # 認証用の情報を格納する
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CLIENT_SECRET_PATH),
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR)
    # アクセストークンを持ってくる（失敗したらエラー？）
    authorizer.fetch_access_token!
    # authorizerをリターン
    authorizer
  end

  #レスポンスとして受け取るEventをコンソールに表示
  def puts_event(event)
    puts "Summary:  #{event.summary}"
    puts "Location: #{event.location}"
    puts "ID:       #{event.id}"
    puts "Start:    #{event.start.date_time}"
    puts "End:      #{event.end.date_time}"
  end

  #必要な情報をEventクラスのインスタンスとして格納
  def set_event(summary, description, location, start_time, end_time)
    Google::Apis::CalendarV3::Event.new({
        summary: summary,
        description: description,
        location: location,
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: start_time
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: end_time
        )
      }
    )
  end

  # 新しい予定の作成
  def create
    #イベントを作成
    event = set_event(
      'inserted test event',
      'test event',
      'test',
      DateTime.new(2020, 8, 23, 12),
      DateTime.new(2020, 8, 23, 15)
    )

    #作成のリクエストを送信し、レスポンスを受け取る
    response =  @service.insert_event(
      @calendar_id,  #calendarID, 必須
      event #挿入したいイベント(Google::Apis::CalendarV3::Event)
    )

    puts_event(response)
  end

  #期間を指定してEventのリストを取得
  def read
    # 2020年の1月から12月1日までの予定を取ってくる
    events = @service.list_events(@calendar_id,
                                  time_min: (Time.new(2020, 1, 1)).iso8601,
                                  time_max: (Time.new(2020, 12, 1)).iso8601,
                                 )
    events.items.each do |event|
      puts '-------------------------------'
      puts_event(event)
    end
  end

  #指定したevent情報を更新
  def update(event_id)
    #イベントを作成
    event = set_event(
      'updated test event',
      'updated test event',
      'updated',
      DateTime.new(2020, 8, 24, 12),
      DateTime.new(2020, 8, 24, 15)
    )

    #リクエストを送信し、レスポンスを受け取る
    response =  @service.update_event(
      @calendar_id,  #calendarID, 必須
      event_id, #編集したいeventのID
      event #挿入したいイベント(Google::Apis::CalendarV3::Event)
    )

    puts_event(response)
  end

  def delete(event_id)
    @service.delete_event(
      @calendar_id,
      event_id
    )
  end
end

Calendar.new.read