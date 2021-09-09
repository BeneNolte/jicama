class GoogleApiJob < ApplicationJob
  queue_as :default

  def perform(service)
    # Do something later
    tlds = ["com", "gov", "net", "mil", "org", "ac", "ad", "ae", "af", "ag", "ai", "al", "am", "an", "ao", "aq", "ar",
            "as", "at", "au", "aw", "ax", "az", "ba", "bb", "bd", "be", "bf", "bg", "bh", "bi", "bj", "bm", "bn", "bo", "br",
            "bs", "bt", "bv", "bw", "by", "bz", "ca", "cc", "cd", "cf", "cg", "ch", "ci", "ck", "cl", "cm", "cn", "co", "cr",
            "cs", "cu", "cv", "cw", "cx", "cy", "cz", "dd", "de", "dj", "dk", "dm", "do", "dz", "ec", "ee", "eg", "eh", "er",
            "es", "et", "eu", "fi", "fj", "fk", "fm", "fo", "fr", "ga", "gb", "gd", "ge", "gf", "gg", "gh", "gi", "gl", "gm",
            "gn", "gp", "gq", "gr", "gs", "gt", "gu", "gw", "gy", "hk", "hm", "hn", "hr", "ht", "hu", "id", "ie", "il", "im",
            "in", "io", "iq", "ir", "is", "it", "je", "jm", "jo", "jp", "ke", "kg", "kh", "ki", "km", "kn", "kp", "kr", "kw",
            "ky", "kz", "la", "lb", "lc", "li", "lk", "lr", "ls", "lt", "lu", "lv", "ly", "ma", "mc", "md", "me", "mg", "mh",
            "mk", "ml", "mm", "mn", "mo", "mp", "mq", "mr", "ms", "mt", "mu", "mv", "mw", "mx", "my", "mz", "na", "nc", "ne",
            "nf", "ng", "ni", "nl", "no", "np", "nr", "nu", "nz", "om", "pa", "pe", "pf", "pg", "ph", "pk", "pl", "pm", "pn",
            "pr", "ps", "pt", "pw", "py", "qa", "re", "ro", "rs", "ru", "rw", "sa", "sb", "sc", "sd", "se", "sg", "sh", "si",
            "sj", "sk", "sl", "sm", "sn", "so", "sr", "ss", "st", "su", "sv", "sx", "sy", "sz", "tc", "td", "tf", "tg", "th",
            "tj", "tk", "tl", "tm", "tn", "to", "tp", "tr", "tt", "tv", "tw", "tz", "ua", "ug", "uk", "us", "uy", "uz", "va",
            "vc", "ve", "vg", "vi", "vn", "vu", "wf", "ws", "ye", "yt", "yu", "za", "zm", "zw"]

    @list_of_companies = []
    user_id = "me"
    result = service.list_user_messages(user_id)
    message_tester = result.messages
    message_tester.each_with_index do |email, index|
      message = service.get_user_message(user_id, email.id, fields: "payload/headers")
      # p (index + 1)

      message.payload.headers.each do |header|
        if header.name == "From"
          # binding.pry
          sender_email = header.value.chop!.split("@").last.split(".")  #.match(/d=(\w+(.\w+){1,})/)[1] #if header.name == "DKIM-Signature"
          sender_email.reject! { |part| tlds.include?(part) }
          @list_of_companies << sender_email.last
        end
      end
    end

    return @list_of_companies.tally
  end
end
