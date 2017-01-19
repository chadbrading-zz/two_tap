defmodule FakeAMQP do
  defmodule Basic do
    def ack(_, _, _ \\ []) do
      :ok
    end

    def reject(_, _, _ \\ []) do
      :ok
    end
  end
end
