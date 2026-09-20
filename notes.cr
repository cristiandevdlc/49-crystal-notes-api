require "http/server"
require "json"

struct Note
  include JSON::Serializable
  property id : Int32
  property text : String
  def initialize(@id, @text); end
end

notes = [] of Note
server = HTTP::Server.new do |context|
  context.response.content_type = "application/json"
  if context.request.path == "/health"
    context.response.print({status: "ok"}.to_json)
  elsif context.request.path == "/notes" && context.request.method == "GET"
    context.response.print(notes.to_json)
  elsif context.request.path == "/notes" && context.request.method == "POST"
    payload = JSON.parse(context.request.body.not_nil!).as_h; text = payload["text"].as_s.strip
    if text.empty? then context.response.status_code = 400; context.response.print({error: "text obligatorio"}.to_json)
    else note = Note.new(notes.size + 1, text); notes << note; context.response.status_code = 201; context.response.print(note.to_json) end
  else context.response.status_code = 404; context.response.print({error: "Ruta no encontrada"}.to_json) end
end
puts "Crystal Notes API: http://localhost:8083"; server.bind_tcp "127.0.0.1", 8083; server.listen
