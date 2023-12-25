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
  @topic "live"
  # CounterWeb 모듈에서 :live_view 관련 기능을 가져와 사용

  # mount 함수는 LiveView가 마운트될 때 호출됩니다.
  # 초기 상태를 설정하는 데 사용되며,
  # 여기서는 소켓에 :val이라는 이름으로 0을 할당합니다.
  def mount(_params, _session, socket) do
    # 설명
    # 특정 토픽에 대한 구독을 설정합니다.
    CounterWeb.Endpoint.subscribe(@topic)

    # 상태를 설정합니다.
    # :val 이라는 키를 가진 상태를 할당하고, 그 값으로 0을 할당합니다.

    {:ok, assign(socket, :val, 0)}
  end

  # handle_event 함수는 특정 이벤트를 처리합니다.
  # "inc" 이벤트가 발생하면 :val 값을 1 증가시킵니다.
  # CounterWeb.Endpoint.broadcast_from/4 함수를 사용하여
  # 현재 프로세스(self())에서 @topic이라는 주제로
  # "inc" 이벤트와 함께 새로운 상태(new_state.assigns)를 브로드캐스트합니다.
  # 이를 통해 같은 토픽을 구독하는 다른 클라이언트나 서버 사이드 프로세스에게
  # 이벤트를 알립니다.
  def handle_event("inc", _value, socket) do
    new_state = update(socket, :val, &(&1 + 1))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)

    # {:noreply, new_state}를 반환하여,
    # 이벤트에 대한 응답으로 추가적인 메시지를 보내지 않고,
    # 소켓의 상태를 new_state로 업데이트
    {:noreply, new_state}
  end

  # "dec" 이벤트에 대해서는 :val 값을 1
  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, &(&1 - 1))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  @doc """
  handler_info/2는 msg가 수신된 메시지이고,
  소켓이 Phoenix.Socket인 Elixir 프로세스 메시지를 처리합니다.
  마지막으로 우리는 좀 더 시각적으로 매력적이도록,
  render/1 함수 내부의 HTML을 수정했습니다.
  """
  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  # render 함수는 LiveView의 HTML을 렌더링합니다.
  # ~H 시그릴은 HTML을 Elixir 코드 내에서 사용할 수 있습니다.
  def render(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="teext-4xl font-bold text-center">Count: <%= @val %></h1>
      <.button phx-click="dec">-</.button>
      <.button phx-click="inc">+</.button>
    </div>
    """
  end
end
