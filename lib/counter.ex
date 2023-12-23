defmodule CounterWeb.Counter do
  @moduledoc """
  Counter keeps the contexts that define your domain
  and business logic.
  모듈이 도메인과 비즈니스 로직을 정의하는 컨텍스트를 유지
  컨텍스트는 또한 데이터베이스나 외부 API에서 가져오든 데이터베이스에서 가져온 것이든 외부 API에서 가져온 것이든 상관없습니다.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use CounterWeb, :live_view
  # CounterWeb 모듈에서 :live_view 관련 기능을 가져와 사용

  # mount 함수는 LiveView가 마운트될 때 호출됩니다.
  # 초기 상태를 설정하는 데 사용되며,
  # 여기서는 소켓에 :val이라는 이름으로 0을 할당합니다.
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  # handle_event 함수는 특정 이벤트를 처리합니다.
  # "inc" 이벤트가 발생하면 :val 값을 1 증가시킵니다.
  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  # "dec" 이벤트에 대해서는 :val 값을 1
  def handle_event("dev", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  # render 함수는 LiveView의 HTML을 렌더링합니다.
  # ~H 시그릴은 HTML을 Elixir 코드 내에서 사용할 수 있습니다.
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="teext-4xl font-bold text-center">The count is: <%= @val %></h1>

      <p class="text-center">
        <.button phx-click="dec">-</.button>
        <.button phx-click="inc">+</.button>
      </p>
    </div>
    """
  end
end
