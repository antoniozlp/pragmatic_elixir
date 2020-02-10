defmodule Servy.Handler do
    def handle(request) do
        # conv = parse(request)
        # conv = router(request)
        # format_responce(conv)

        # +++Elixir pipe operator+++
        request 
        |> parse 
        |> route 
        |> format_responce
    end

    def parse(request) do
        first_line = request |> String.split("\n") |> List.first
        [method, path, _] = String.split(first_line, " ")
        %{ method: method, path: path, resp_body: ""}
    end

    def route(conv) do
        #Todo: Create a new map that also has the responce body:
        conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
    end

    def format_responce(conv) do
        #Todo: Use values in the map to create an HTTP response string
        """
        HTTP/1.1 200 OK
        Content-Type: text/html
        Content-Length: 20
        
        Bears, Lions, Tigers
        """
    end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""



responce = Servy.Handler.handle(request)

IO.puts responce