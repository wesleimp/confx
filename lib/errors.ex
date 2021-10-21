defmodule Confx.FileNotFoundError do
  defexception [:message]

  @impl true
  def exception(path) do
    %__MODULE__{
      message: "configuration file: #{path} could not be found"
    }
  end
end

defmodule Confx.FileFormatNotFoundError do
  defexception [:message]

  @impl true
  def exception(path) do
    %__MODULE__{
      message: "configuration file: #{path} is not a registered file format"
    }
  end
end
