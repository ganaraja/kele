require "httparty"
require "roadmap"

class InvalidStudentCodeError < StandardError
  def initialize(msg="invalid email or password")
    super(msg)
  end
end

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post(base_api_endpoint("sessions"), body: { "email": email, "password": password })
    raise InvalidStudentCodeError.new() if response.code == 401
    @auth_token = response["auth_token"]
  end

  def get_me
    unless @auth_token.nil?
      response = self.class.get(base_api_endpoint("users/me"), headers: { "authorization" => @auth_token })
      @user_data = JSON.parse(response.body)
      # @user_data.keys.each do |key|
      #   self.class.send(:define_method, key.to_sym) do
      #     @user_data[key]
      #   end
      # end
    else
      puts "auth_token is nil"
    end
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_api_endpoint("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end


  def get_messages(page=nil)
    if page.nil?
      response = self.class.get(base_api_endpoint("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(base_api_endpoint("message_threads?page=#{page}"), headers: { "authorization" => @auth_token })
    end
    @get_messages = JSON.parse(response.body)
  end

  def create_message(recipient_id, subject, message)
    response = self.class.post(base_api_endpoint("messages"), body: { "user_id": id, "recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
    puts response
  end

  def create_submissions(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    response = self.class.post(base_api_endpoint("checkpoint_submissions"), body: { "checkpoint_id": checkpoint_id, "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "comment": comment }, headers: { "authorization" => @auth_token })
    puts response
  end
  private
    def base_api_endpoint(end_point)
      "https://www.bloc.io/api/v1/#{end_point}"
    end

  end
