defmodule InfoSysTest do
  use ExUnit.Case
  alias InfoSys.Result

  defmodule TestBackend do
    def name, do: "wolfram"

    def compute("result", _opts) do
      [%Result{backend: __MODULE__, text: "result"}]
    end

    def compute("none", _opts) do
      []
    end

    def compute("timeout", _opts) do
      Process.sleep(:infinity)
    end

    def compute("boom", _opts) do
      raise "boom"
    end
  end

  test "compute/2 with backend result" do
    assert [%Result{backend: TestBackend, text: "result"}] = InfoSys.compute("result", backends: [TestBackend])
  end

  test "compute/2 with NO backend result" do
    assert [] = InfoSys.compute("none", backends: [TestBackend])
  end

  test "compute/2 timeout" do
    results = InfoSys.compute("timeout", backends: [TestBackend], timeout: 10)
    assert results == []
  end
end
