defmodule CounterWeb.Router do
  use CounterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CounterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # 범위` 블록은 경로 그룹을 정의합니다.
  # 첫 번째 매개변수 "/"는 이 블록에 정의된 모든 경로 앞에 "/"가 붙는다는 것을 나타냅니다.
  # 범위 블록의 CounterWeb은 컨트롤러 모듈을 찾을 모듈입니다.
  scope "/", CounterWeb do
    # pipe_through :브라우저는 이 범위가 위에 정의된 :브라우저 파이프라인을 사용하도록 지정합니다.
    # 이 파이프라인에는 브라우저 요청을 처리하는 데 필요한 공통 플러그가 포함되어 있습니다.
    pipe_through :browser

    # 루트("/") 경로에 GET 요청을 일치시키는 경로입니다.
    # GET 요청이 "/"와 일치하면 PageController의 `home` 함수가 호출됩니다.
    # get "/", PageController, :home
    live("/", Counter)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CounterWeb do
  #   pipe_through :api
  # end
end
