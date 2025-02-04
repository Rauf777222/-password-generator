defmodule PasswordGenerator do
  @moduledoc """
  A simple password generator supporting character and word-based passwords.
  """

  @chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
  @words ["apple", "orange", "table", "chair", "laptop", "screen", "light", "window"]

  def generate(opts) do
    type = Keyword.get(opts, :type, :chars)
    min_length = Keyword.get(opts, :min_length, 8)
    max_length = Keyword.get(opts, :max_length, 16)

    case type do
      :chars -> generate_chars(min_length, max_length, opts)
      :words -> generate_words(min_length, max_length, opts)
      _ -> {:error, "Invalid type. Use :chars or :words"}
    end
  end

  defp generate_chars(min, max, opts) do
    length = Enum.random(min..max)
    chars = @chars |> String.graphemes() |> Enum.shuffle() |> Enum.take(length) |> Enum.join("")

    if Keyword.get(opts, :uppercase, false) do
      apply_random_uppercase(chars)
    else
      chars
    end
  end

  defp generate_words(min, max, opts) do
    length = Enum.random(min..max)
    words = @words |> Enum.shuffle() |> Enum.take(length)
    separator = Keyword.get(opts, :separator, "-")

    password = Enum.join(words, separator)

    if Keyword.get(opts, :uppercase, false) do
      String.capitalize(password)
    else
      password
    end
  end

  defp apply_random_uppercase(password) do
    password
    |> String.graphemes()
    |> Enum.map(fn ch -> if Enum.random(0..1) == 1, do: String.upcase(ch), else: ch end)
    |> Enum.join("")
  end
end

# Example usage:
IO.puts PasswordGenerator.generate(type: :chars, min_length: 10, max_length: 20, uppercase: true)
IO.puts PasswordGenerator.generate(type: :words, min_length: 2, max_length: 5, separator: "+", uppercase: true)
