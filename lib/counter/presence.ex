# Phoenix에는 얼마나 많은 사람(연결된 클라이언트)이
# 우리 시스템을 사용하고 있는지 추적하는 Presence라는 매우 멋진 기능이 있습니다.
# 클라이언트 수를 세는 것 이상의 역할을 하지만 이것은 계산 앱이므로 ...
# 우선 우리는 Presence를 사용할 것임을 애플리케이션에 알려야 합니다.
# 이를 위해 lib/counter/presence.ex 파일을 생성하고 다음 코드 줄을 추가해야 합니다.
defmodule Counter.Presence do
  use Phoenix.Presence,
    otp_app: :counter,
    pubsub_server: Counter.PubSub
end
