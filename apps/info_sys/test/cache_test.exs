defmodule InfoSysTest.CacheTest do
  use ExUnit.Case, async: true
  alias InfoSys.Cache

  @moduletag clear_interval: 100

  setup %{test: name, clear_interval: clear_interval} do
    {:ok, pid} = Cache.start_link(name: name, clear_interval: clear_interval)
    {:ok, name: name, pid: pid}
  end

  test "key/value pair can put and fetched from cache", %{name: name} do
    assert :ok = Cache.put(name, :key1, :value1)
    assert Cache.fetch(name, :key1) == {:ok, :value1}
  end

  test "unfound key return error", %{name: name} do
    assert :error = Cache.fetch(name, :notexist)
  end

  test "clear all entries after interval", %{name: name} do
    assert :ok = Cache.put(name, :key1, :value1)
    assert Cache.fetch(name, :key1) == {:ok, :value1}
    assert eventually(fn -> Cache.fetch(name, :key1) == :error end)
  end

  @tag clear_interval: 60_000
  test "values are cleaned up on exit", %{name: name, pid: pid} do
    assert :ok = Cache.put(name, :key1, :value1)
    assert_shutdown(pid)
    {:ok, _cache} = Cache.start_link(name: name)
    assert Cache.fetch(name, :key1) == :error
  end

  defp assert_shutdown(pid) do
    ref = Process.monitor(pid)
    Process.unlink(pid)
    Process.exit(pid, :kill)

    assert_receive {:DOWN, ^ref, :process, ^pid, :killed}
  end

  defp eventually(func) do
    if func.() do
      true
    else
      Process.sleep(100)
      eventually(func)
    end
  end
end
