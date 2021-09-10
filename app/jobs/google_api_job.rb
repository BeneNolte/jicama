class GoogleApiJob < ApplicationJob
  queue_as :default

  def perform(service)
    # Do something later
    tlds = ["com", "edu", "gov", "net", "mil", "org", "ac", "ad", "ae", "af", "ag", "ai", "al", "am", "an", "ao", "aq", "ar",
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
    message_tester.each do |email|
      message = service.get_user_message(user_id, email.id, fields: "payload/headers")

      message.payload.headers.each do |header|
        @company = {}

        if header.name == "From"
          ## Getting domain :
          domain = header.value.chomp(">").split("@").last.split(".")
          domain.reject! { |part| tlds.include?(part) }
          @company[:company_domain] = domain.last

          ## redeem email :
          email_address = header.value.split("<").last
          @company[:email] = email_address
        end

        @list_of_companies << @company unless @company.empty?
      end
    end

    @list_of_companies = @list_of_companies.tally.to_a

    @list_of_companies.each do |company|
      company.first[:number_of_emails] = company.last
      company.pop
    end
    @list_of_companies.flatten!
    @list_of_companies.sort_by! { |h| h[:company_domain] }

    @unwanted_compagnies = ["google", "apple", ".edu", "gmail", "youtube"]

    def filter
      (0..@list_of_companies.count).to_a.each do |index|
        unless @list_of_companies[index + 1].nil?
          if @list_of_companies[index][:company_domain] == @list_of_companies[index + 1][:company_domain]
            @list_of_companies[index][:number_of_emails] += @list_of_companies[index + 1][:number_of_emails]
            @list_of_companies.delete_at(index + 1)
          end

          if @unwanted_compagnies.any? { |company| @list_of_companies[index][:email].include? company }
            @list_of_companies.delete_at(index)
          end
          if @unwanted_compagnies.any? { |company| @list_of_companies[index][:company_domain].include? company }
            @list_of_companies.delete_at(index)
          end

        end
      end
    end

    10.times { filter }
    return @list_of_companies
  end
end
