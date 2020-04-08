defmodule InfoSys.Counter do
  use GenServer

  def init(init_val) do
    Process.send_after(self(), :tick, 1000)
    {:ok, init_val}
  end

  def inc(pid), do: GenServer.cast(pid, :inc)
  def dec(pid), do: GenServer.cast(pid, :dec)

  def val(pid) do
    GenServer.call(pid, :val)
  end

  def start_link(init_val) do
    GenServer.start_link(__MODULE__, init_val)
  end

  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end

  def handle_call(:val, _from, val) do
    {:reply, val, val}
  end

  def handle_info(:tick, val) when val <= 0, do: raise "boom!"
  def handle_info(:tick, val) do
    IO.puts("tick: #{val}")
    Process.send_after(self(), :tick, 1000)
    {:noreply, val - 1}
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      restart: :temporary,
      shutdown: 5000,
      type: :worker,
    }
  end
end
