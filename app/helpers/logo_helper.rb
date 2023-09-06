module LogoHelper
    def show_logo_text(path)
        if File.file?("app/assets/images/#{path}")
            text = "<b> for </b>"
            text.html_safe
        end
    end

    def show_svg(path)
        if File.file?("app/assets/images/#{path}")
            File.open("app/assets/images/#{path}", "rb") do |file|
                raw file.read
            end
        end
    end
end