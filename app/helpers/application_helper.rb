module ApplicationHelper
    def devise_error_messages
      return "" if resource.errors.empty?
      html = ""
      # エラーメッセージ用のHTMLを生成
      messages = resource.errors.full_messages.each do |msg|
        html += <<-EOF
          <div class="error_field alert alert-danger" role="alert">
            <p class="error_msg">#{msg}</p>
          </div>
        EOF
      end
      html.html_safe
    end
  
    def translated_name
      if I18n.locale == :ja
        "#{ja_name}"
      elsif I18n.locale == :en
        "#{en_name}"
      end
    end
  end
  