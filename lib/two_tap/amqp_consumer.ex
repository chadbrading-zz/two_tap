defmodule TwoTap.AMQPConsumer do
  use GenServer
  use AMQP

  @exchange "test_exchange"
  @queue "test_queue"
  @queue_error "test_queue_error"

  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_) do
    rabbitmq_connect
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    TwoTap.CheckoutSupervisor.start_child(chan, tag, redelivered, payload)
    {:noreply, chan}
  end

  def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
    {:ok, chan} = rabbitmq_connect
    {:noreply, chan}
  end

  defp rabbitmq_connect do
    case Connection.open("amqp://guest:guest@localhost") do
      {:ok, conn} ->
        Process.monitor(conn.pid)
        {:ok, chan} = Channel.open(conn)
        Queue.declare(chan, @queue_error, durable: true)
        Queue.declare(chan, @queue, durable: true)
        Exchange.fanout(chan, @exchange, durable: true)
        Queue.bind(chan, @queue, @exchange)
        {:ok, _consumer_tag} = Basic.consume(chan, @queue)
        {:ok, chan}
      {:error, _} ->
        :timer.sleep(10000)
        rabbitmq_connect
    end
  end
end
