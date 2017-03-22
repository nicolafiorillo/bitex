defmodule Bitex.Keypair do
  use GenServer

  @moduledoc """
  Documentation for Keypair.
  """

  require Logger

  def start_link(options \\ []) do
      GenServer.start_link(__MODULE__, :ok, options)
  end

  def init(:ok) do
    Logger.info("Loading keys...")
    Bitex.Key.generate_keys()
    {:ok, []}
  end

  # def handle_cast(:load, _state) do
  #   {:noreply, load_data()}
  # end
  #
  # def handle_call({:search_start, string}, _from, database) do
  #   res = Enum.filter(database, fn {name, _foods} ->
  #     String.starts_with?(name, string)
  #   end)
  #   {:reply, res, database}
  # end
end
