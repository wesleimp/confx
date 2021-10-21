defmodule Confx do
  @moduledoc """
  Documentation for `Confx`.
  """

  @doc """
  Returns the configuration specified in the given file

  ## Options

  The accepted options are:

    * `defaults`: If some key could not be found, the default will be assumed
  """
  @spec load(term(), Keyword.t()) ::
          {:ok, map()}
          | {:error, :file_not_found}
          | {:error, :file_format_not_found}
          | {:error, atom()}
  def load(path, opts \\ []) do
    defaults = opts[:defaults] || []

    with {:ok, format} <- file_format(path),
         {:ok, content} <- read_file(path),
         {:ok, config} <- parse_file(content, format) do
      defaults = keyword_to_map(defaults)

      conf =
        config
        |> keys_to_atom()
        |> then(&merge(defaults, &1))

      {:ok, conf}
    else
      {:error, %{}} ->
        {:error, :parsing_error}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Same as `load/2` but returns the config map directly, or raises an exception if
  an error is returned
  """
  @spec load!(term(), Keyword.t()) :: map()
  def load!(path, opts \\ []) do
    case load(path, opts) do
      {:ok, config} ->
        config

      {:error, :file_format_not_found} ->
        raise Confx.FileFormatNotFoundError, path

      {:error, :file_not_found} ->
        raise Confx.FileNotFoundError, path
    end
  end

  defp parse_file(content, format) do
    case format do
      :json ->
        Jason.decode(content)

      :yaml ->
        YamlElixir.read_from_string(content)
    end
  end

  defp file_format(path) do
    case Path.extname(path) do
      ".json" ->
        {:ok, :json}

      ext when ext in [".yml", ".yaml"] ->
        {:ok, :yaml}

      _ ->
        {:error, :file_format_not_found}
    end
  end

  defp read_file(path) do
    case File.read(path) do
      {:ok, content} ->
        {:ok, content}

      {:error, _} ->
        {:error, :file_not_found}
    end
  end

  defp merge(left, right) do
    Map.merge(left, right, &merge_resolve/3)
  end

  defp merge_resolve(_key, %{} = left, %{} = right), do: merge(left, right)
  defp merge_resolve(_key, _left, right), do: right

  defp keys_to_atom(str_key_map) when is_map(str_key_map) do
    for {key, val} <- str_key_map, into: %{}, do: {String.to_atom(key), keys_to_atom(val)}
  end

  defp keys_to_atom(value), do: value

  defp keyword_to_map([]), do: %{}

  defp keyword_to_map(keyword_list) when is_list(keyword_list) do
    for {key, val} <- keyword_list, into: %{}, do: {key, keyword_to_map(val)}
  end

  defp keyword_to_map(val), do: val
end
