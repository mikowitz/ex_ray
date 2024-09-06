defmodule ExRay.Progress do
  use GenServer

  def start_link(worker_count) do
    percentages = for _ <- 1..worker_count, do: 0

    GenServer.start_link(__MODULE__, percentages, name: __MODULE__)
  end

  def init(percs) do
    {:ok, percs}
  end

  def update(index, ct) do
    GenServer.cast(__MODULE__, {:update, index, ct})
  end

  def handle_cast({:update, index, n}, state) do
    new_state = List.replace_at(state, index, n)

    avg = round(Enum.sum(new_state) / length(new_state))

    line =
      [
        IO.ANSI.clear_line(),
        "\r",
        Enum.map_join(new_state, "", &String.pad_leading("#{&1}%", 6)),
        String.pad_leading("(#{avg}%)", 8)
      ]
      |> Enum.join()

    IO.write(line)

    {:noreply, new_state}
  end
end
