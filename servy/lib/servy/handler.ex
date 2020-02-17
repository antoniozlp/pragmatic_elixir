defmodule Servy.Handler do
    @moduledoc "Handles HTTP requests."
    
    alias Servy.Conv

    @pages_path Path.expand("../../pages", __DIR__)
    
    import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
    import Servy.Parser, only: [parse: 1]

    @doc "Transform the request into a response "
    def handle(request) do
        # +++Elixir pipe operator+++
        request 
        |> parse
        |> rewrite_path
        |> log 
        |> route
        |> track 
        |> format_responce
    end

    def route(%Conv{ method: "GET", path: "/wildthings"} = conv) do
        %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
    end

    def route(%Conv{ method: "GET", path: "/bears"} = conv) do
        %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
    end

    def route(%Conv{ method: "GET", path: "/bears" <> id } = conv) do
        %{conv | status: 200, resp_body: "Bear #{id}"}
    end

    def route(%Conv{method: "POST", path: "/bears"} = conv) do
        %{conv | status: 201,
                 resp_body: "Create a #{conv.params["type"]} bear nemad #{conv.params["name"]}!"}
    end

    def route(%Conv{ method: "GET", path: "/about"} = conv) do
        @pages_path
        |> Path.join("about.html")
        |> File.read
        |> handle_file(conv)
    end

    def route(%Conv{ path: path} = conv) do
        %{conv | status: 404, resp_body: "No #{path} here!"}
    end


    def handle_file({:ok, content}, conv) do
        %{conv | status: 500, resp_body: content}
    end

    def handle_file({:error, :enoent}, conv) do
        %{conv | status: 404, resp_body: "File not found!"}
    end

    def handle_file({:error, reason}, conv) do
        %{conv | status: 500, resp_body: "File error: #{reason}"}
    end

    # def route(%{ method: "GET", path: "/about"} = conv) do
    #     file = 
    #       Path.expand("../../pages", __DIR__)
    #       |> Path.join("about.html")

    #     case File.read(file) do    # I not understand how works /../..
    #         {:ok, content} ->
    #             %{conv | status: 500, resp_body: content}
    #         {:error, :enoent} ->
    #             %{conv | status: 404, resp_body: "File not found!"}
    #         {:error, reason} ->
    #             %{conv | status: 500, resp_body: "File error: #{reason}"}
    #     end
    # end



    def format_responce(%Conv{} = conv) do
        """
        HTTP/1.1 #{Conv.full_status(conv)}
        Content-Type: text/html
        Content-Length: #{String.length(conv.resp_body)} 
        
        #{conv.resp_body}
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



request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
responce = Servy.Handler.handle(request)

IO.puts responce



request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
responce = Servy.Handler.handle(request)

IO.puts responce


request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
responce = Servy.Handler.handle(request)

IO.puts responce

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

responce = Servy.Handler.handle(request)

IO.puts responce

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

responce = Servy.Handler.handle(request)

IO.puts responce

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: multipart/from-data
Content-Length: 21

name=Baloo&type=Brown
"""

responce = Servy.Handler.handle(request)

IO.puts responce

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

responce = Servy.Handler.handle(request)

IO.puts responce


