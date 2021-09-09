class GoogleApiJob < ApplicationJob
  queue_as :default

  def perform(service)
    # Do something later
    company_title_arr = []
    user_id = "me"
    result = service.list_user_messages(user_id, max_results: 5)
    message_tester = result.messages
    message_tester.each_with_index do |email, index|
      message = service.get_user_message(user_id, email.id, fields: "payload/headers")
      message.payload.headers.each do |header|
        if header.name == "From"
          company_title_arr << header.value.split(" ")[0]  #.match(/d=(\w+(.\w+){1,})/)[1] #if header.name == "DKIM-Signature"
        end
      end
    end
    return company_title_arr
  end
end
