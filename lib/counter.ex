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

  alias Counter.Count
  alias Phoenix.PubSub
  alias Counter.Presence

  @topic Count.topic()
  @presence_topic "presence"

  # CounterWeb 모듈에서 :live_view 관련 기능을 가져와 사용

  # mount 함수는 LiveView가 마운트될 때 호출됩니다.
  # 초기 상태를 설정하는 데 사용되며,
  # 여기서는 소켓에 :val이라는 이름으로 0을 할당합니다.
  def mount(_params, _session, socket) do
    # 설명
    # 특정 토픽에 대한 구독을 설정합니다.
    PubSub.subscribe(Counter.PubSub, @topic)

    Presence.track(self(), @presence_topic, socket.id, %{})
    CounterWeb.Endpoint.subscribe(@presence_topic)

    initial_present =
      Presence.list(@presence_topic)
      |> map_size

    {:ok, assign(socket, val: Count.current(), present: initial_present)}

    # 상태를 설정합니다.
    # :val 이라는 키를 가진 상태를 할당하고, 그 값으로 0을 할당합니다.
  end

  # handle_event 함수는 특정 이벤트를 처리합니다.
  # "inc" 이벤트가 발생하면 :val 값을 1 증가시킵니다.
  # CounterWeb.Endpoint.broadcast_from/4 함수를 사용하여
  # 현재 프로세스(self())에서 @topic이라는 주제로
  # "inc" 이벤트와 함께 새로운 상태(new_state.assigns)를 브로드캐스트합니다.
  # 이를 통해 같은 토픽을 구독하는 다른 클라이언트나 서버 사이드 프로세스에게
  # 이벤트를 알립니다.
  def handle_event("inc", _value, socket) do
    {:noreply, assign(socket, :val, Count.incr())}
  end

  # "dec" 이벤트에 대해서는 :val 값을 1
  def handle_event("dec", _, socket) do
    {:noreply, assign(socket, :val, Count.decr())}
  end

  @doc """
  handler_info/2는 msg가 수신된 메시지이고,
  소켓이 Phoenix.Socket인 Elixir 프로세스 메시지를 처리합니다.
  마지막으로 우리는 좀 더 시각적으로 매력적이도록,
  render/1 함수 내부의 HTML을 수정했습니다.
  """
  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, val: count)}
  end

  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{present: present}} = socket
      ) do
    new_present = present + map_size(joins) - map_size(leaves)
    {:noreply, assign(socket, :present, new_present)}
  end

  # render 함수는 LiveView의 HTML을 렌더링합니다.
  # ~H 시그릴은 HTML을 Elixir 코드 내에서 사용할 수 있습니다.
  def render(assigns) do
    ~H"""
    <.live_component module={CounterComponent} id="counter" val={@val} />

    <.live_component module={PresenceComponent} id="presence" present={@present} />
    """
  end
end
