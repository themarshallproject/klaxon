module BookmarkletHelper
  def bookmarklet_js_v2
    file_path = Rails.root.join("public", "bookmarklet.js")
    return "" unless File.exist?(file_path)

    js_content = File.read(file_path)
    "javascript:(function(){#{js_content}})();"
  end
end
