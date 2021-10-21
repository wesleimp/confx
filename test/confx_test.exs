defmodule ConfxTest do
  use ExUnit.Case
  doctest Confx

  describe "load/" do
    test "loads he file" do
      assert {:ok,
              %{
                confx: %{
                  first: "first",
                  second: 2
                }
              }} = Confx.load("./test/support/testdata/config.yml")

      assert {:ok,
              %{
                confx: %{
                  first: "first",
                  second: 2
                }
              }} = Confx.load("./test/support/testdata/config.json")
    end

    test "loads the file with some defaults" do
      assert {:ok,
              %{
                confx: %{
                  first: "first",
                  second: 2,
                  third: true
                }
              }} =
               Confx.load("./test/support/testdata/config.json",
                 defaults: [confx: [first: "default", third: true]]
               )
    end

    test "loads the file with nested defaults" do
      assert {:ok,
              %{
                confx: %{
                  first: "first",
                  second: 2,
                  third: true,
                  fourth: %{
                    fifth: %{
                      sixth: 6
                    }
                  }
                }
              }} =
               Confx.load("./test/support/testdata/config.json",
                 defaults: [confx: [first: "default", third: true, fourth: [fifth: [sixth: 6]]]]
               )
    end

    test "returns error when loads invalid file" do
      assert {:error, :parsing_error} = Confx.load("./test/support/testdata/invalid.yml")
    end

    test "returns error for invalid file format" do
      assert {:error, :file_format_not_found} = Confx.load("./test/support/testdata/config.env")
    end

    test "returns error not found file" do
      assert {:error, :file_not_found} = Confx.load("./test/support/testdata/not_found.yml")
    end
  end

  describe "load!/2" do
    test "raises a file not found exception" do
      message = "configuration file: test/support/testdata/not_found.yml could not be found"

      assert_raise Confx.FileNotFoundError, message, fn ->
        Confx.load!("test/support/testdata/not_found.yml")
      end
    end

    test "raises a file format not found exception" do
      message =
        "configuration file: test/support/testdata/foo.env is not a registered file format"

      assert_raise Confx.FileFormatNotFoundError, message, fn ->
        Confx.load!("test/support/testdata/foo.env")
      end
    end
  end
end
