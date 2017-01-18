defmodule TwoTap.CheckoutSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(channel, tag, redelivered, payload) do
    Supervisor.start_child(__MODULE__, [channel, tag, redelivered, payload])
  end

  def init(_) do
    :ets.new(:checkout_registry, [:set, :named_table, :public])
    children = [worker(TwoTap.CheckoutWorker, [], restart: :transient)]
    opts = [strategy: :simple_one_for_one, name: __MODULE__]
    supervise(children, opts)
  end
end
