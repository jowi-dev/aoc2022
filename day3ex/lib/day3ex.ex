defmodule Day3ex do
  @moduledoc """
  Documentation for `Day3ex`.
  """

  def score(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(&score_rucksack/2)
  end

  defp score_rucksack(full_contents, acc) do
    full_contents
    |> bisect_and_filter_contents()
    |> Enum.reduce(acc, fn char, acc -> acc + get_character_score(char) end)
  end

  defp bisect_and_filter_contents(contents) do
    half = String.length(contents) / 2

    {head, tail} = String.split_at(contents, half)

    Enum.filter(head, &(&1 in tail))
  end

  defp get_character_score(char) do 
    points = ?char
    case points do 
      97..122 -> points - 96
      65..90 -> points - 38
    end
  end

end
