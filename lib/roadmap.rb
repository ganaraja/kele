module Roadmap

  def get_roadmap(roadmap_id)
    response = self.class.get(base_api_endpoint("roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

end
