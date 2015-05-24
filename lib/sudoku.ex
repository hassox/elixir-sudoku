defmodule Sudoku do
  def easy, do: Sudoku.solve(Sudoku.easy_board)
  def hardish, do: Sudoku.solve(Sudoku.hardish_board)
  def hard, do: Sudoku.solve(Sudoku.hard_board)

  # Just using 0 rather than nil for display purposes
  def easy_board do
    [
      [8,3,0, 1,0,0, 6,0,5],
      [0,0,0, 0,0,0, 0,8,0],
      [0,0,0, 7,0,0, 9,0,0],

      [0,5,0, 0,1,7, 0,0,0],
      [0,0,3, 0,0,0, 2,0,0],
      [0,0,0, 3,4,0, 0,1,0],

      [0,0,4, 0,0,8, 0,0,0],
      [0,9,0, 0,0,0, 0,0,0],
      [3,0,2, 0,0,6, 0,4,7]
    ]
  end

  def hardish_board do
    [
      [0,8,0, 0,0,6, 0,0,3],
      [0,6,0, 0,7,0, 2,0,0],
      [0,0,4, 0,1,0, 0,9,0],

      [0,5,0, 0,0,0, 8,0,1],
      [0,0,0, 0,0,0, 0,0,0],
      [0,1,3, 0,0,0, 0,6,0],

      [0,0,5, 0,0,9, 0,0,8],
      [0,0,0, 0,2,0, 0,0,0],
      [0,0,6, 7,0,0, 3,0,2],
    ]
  end

  def hard_board do
    [
      [0,0,0, 0,3,7, 6,0,0],
      [0,0,0, 6,0,0, 0,9,0],
      [0,0,8, 0,0,0, 0,0,4],

      [0,9,0, 0,0,0, 0,0,1],
      [6,0,0, 0,0,0, 0,0,9],
      [3,0,0, 0,0,0, 0,4,0],

      [7,0,0, 0,0,0, 8,0,0],
      [0,1,0, 0,0,9, 0,0,0],
      [0,0,2, 5,4,0, 0,0,0],
    ]
  end

  def solve(board) do
    case solve(board, 0, 0) do
      { :ok, solved_board } -> print_board(solved_board)
      { :error } -> IO.puts("Board is not valid")
    end
  end

  def solve(board, x, _) when x==9, do: { :ok, board }
  def solve(board, x, y) when y==9, do: solve(board, x + 1, 0)

  def solve(board, x, y) do
    if Enum.at(Enum.at(board, x), y) == 0 do
      solve(board, x, y, possible_values(board, x, y))
    else
      solve(board, x, y + 1)
    end
  end

  def solve(_, _, _, []), do: { :error }
  def solve(board, x, y, [head | tail]) do
    new_row = Enum.at(board, x) |> List.replace_at(y, head)
    new_board = List.replace_at(board, x, new_row)

    case solve(new_board, x, y + 1) do
      { :ok, solved_board } -> { :ok, solved_board }
      { :error } -> solve(board, x, y, tail)
    end
  end

  def possible_values(board, x, y) do
    vals = [values_in_row(board, x), values_in_column(board, y), values_in_cell(board, x, y)]
            |> List.flatten
            |> Enum.uniq

    (1..9) |> Enum.reject(&(Enum.member?(vals, &1)))
  end

  def values_in_row(board, x), do: Enum.at(board, x)
  def values_in_column(board, y), do: Enum.map(board, &(Enum.at(&1, y)))

  def values_in_cell(board, x, y) do
    start_x = div(x, 3) * 3
    start_y = div(y, 3) * 3
    Enum.slice(board, start_x, 3) |> Enum.map(&(Enum.slice(&1, start_y, 3))) |> List.flatten
  end

  def print_board([]), do: nil
  def print_board([row | rest]) do
    IO.inspect(row)
    print_board(rest)
  end
end
