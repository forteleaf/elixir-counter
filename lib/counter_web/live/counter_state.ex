defmodule Counter.Count do
  use GenServer
  alias Phoenix.PubSub
  @name :count_server

  @start_value 0

  # GenServer는 자체 프로세스에서 실행됩니다.
  # 애플리케이션의 다른 부분은 자체 프로세스에서 API를 호출하며,
  # 이러한 호출은 직렬로 처리되는 GenServer 프로세스의
  # handler_call 함수로 전달됩니다.
  # 또한 PubSub 간행물도 여기로 옮겼습니다.
  # 또한 이제 일부 비즈니스 로직이 있음을 애플리케이션에 알려야 합니다.
  # lib/counter/application.ex 파일의 start/2 함수에서 이 작업을 수행합니다.

  # External API (runs in clinent process)
  def topic do
    "count"
  end

  def start_link(_opts) do
    GenServer.start(__MODULE__, @start_value, name: @name)
  end

  def incr() do
    GenServer.call(@name, :incr)
  end

  def decr() do
    GenServer.call(@name, :decr)
  end

  def current() do
    GenServer.call(@name, :currnet)
  end

  def init(start_count) do
    {:ok, start_count}
  end

  def handle_call(:current, _from, count) do
    {:reply, count, count}
  end

  def handle_call(:incr, _from, count) do
    make_change(count, +1)
  end

  def handle_call(:decr, _from, count) do
    make_change(count, -1)
  end

  defp make_change(count, change) do
    new_count = count + change
    PubSub.broadcast(Counter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end
end

