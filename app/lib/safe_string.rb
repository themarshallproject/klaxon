class SafeString
  # this should always produce a valid UTF-8 string
  # diffing/etc will fail if it's nil, non-utf8, etc
  def self.coerce(dirty)
    dirty.to_s.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, replace: "")
  end
end
