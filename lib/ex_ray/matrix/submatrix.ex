defmodule ExRay.Matrix.Submatrix do
  def submatrix([_, [_e, f, g, h], [_i, j, k, l], [_m, n, o, p]], {0, 0}) do
    [
      [f, g, h],
      [j, k, l],
      [n, o, p]
    ]
  end

  def submatrix([_, [e, _f, g, h], [i, _j, k, l], [m, _n, o, p]], {0, 1}) do
    [
      [e, g, h],
      [i, k, l],
      [m, o, p]
    ]
  end

  def submatrix([_, [e, f, _g, h], [i, j, _k, l], [m, n, _o, p]], {0, 2}) do
    [
      [e, f, h],
      [i, j, l],
      [m, n, p]
    ]
  end

  def submatrix([_, [e, f, g, _h], [i, j, k, _l], [m, n, o, _p]], {0, 3}) do
    [
      [e, f, g],
      [i, j, k],
      [m, n, o]
    ]
  end

  def submatrix([[_a, b, c, d], _, [_i, j, k, l], [_m, n, o, p]], {1, 0}) do
    [
      [b, c, d],
      [j, k, l],
      [n, o, p]
    ]
  end

  def submatrix([[a, _b, c, d], _, [i, _j, k, l], [m, _n, o, p]], {1, 1}) do
    [
      [a, c, d],
      [i, k, l],
      [m, o, p]
    ]
  end

  def submatrix([[a, b, _c, d], _, [i, j, _k, l], [m, n, _o, p]], {1, 2}) do
    [
      [a, b, d],
      [i, j, l],
      [m, n, p]
    ]
  end

  def submatrix([[a, b, c, _d], _, [i, j, k, _l], [m, n, o, _p]], {1, 3}) do
    [
      [a, b, c],
      [i, j, k],
      [m, n, o]
    ]
  end

  def submatrix([[_a, b, c, d], [_e, f, g, h], _, [_m, n, o, p]], {2, 0}) do
    [
      [b, c, d],
      [f, g, h],
      [n, o, p]
    ]
  end

  def submatrix([[a, _b, c, d], [e, _f, g, h], _, [m, _n, o, p]], {2, 1}) do
    [
      [a, c, d],
      [e, g, h],
      [m, o, p]
    ]
  end

  def submatrix([[a, b, _c, d], [e, f, _g, h], _, [m, n, _o, p]], {2, 2}) do
    [
      [a, b, d],
      [e, f, h],
      [m, n, p]
    ]
  end

  def submatrix([[a, b, c, _d], [e, f, g, _h], _, [m, n, o, _p]], {2, 3}) do
    [
      [a, b, c],
      [e, f, g],
      [m, n, o]
    ]
  end

  def submatrix([[_a, b, c, d], [_e, f, g, h], [_i, j, k, l], _], {3, 0}) do
    [
      [b, c, d],
      [f, g, h],
      [j, k, l]
    ]
  end

  def submatrix([[a, _b, c, d], [e, _f, g, h], [i, _j, k, l], _], {3, 1}) do
    [
      [a, c, d],
      [e, g, h],
      [i, k, l]
    ]
  end

  def submatrix([[a, b, _c, d], [e, f, _g, h], [i, j, _k, l], _], {3, 2}) do
    [
      [a, b, d],
      [e, f, h],
      [i, j, l]
    ]
  end

  def submatrix([[a, b, c, _d], [e, f, g, _h], [i, j, k, _l], _], {3, 3}) do
    [
      [a, b, c],
      [e, f, g],
      [i, j, k]
    ]
  end

  def submatrix([_, [_d, e, f], [_g, h, i]], {0, 0}) do
    [[e, f], [h, i]]
  end

  def submatrix([_, [d, _e, f], [g, _h, i]], {0, 1}) do
    [[d, f], [g, i]]
  end

  def submatrix([_, [d, e, _f], [g, h, _i]], {0, 2}) do
    [[d, e], [g, h]]
  end

  def submatrix([[_a, b, c], _, [_g, h, i]], {1, 0}) do
    [[b, c], [h, i]]
  end

  def submatrix([[a, _b, c], _, [g, _h, i]], {1, 1}) do
    [[a, c], [g, i]]
  end

  def submatrix([[a, b, _c], _, [g, h, _i]], {1, 2}) do
    [[a, b], [g, h]]
  end

  def submatrix([[_a, b, c], [_d, e, f], _], {2, 0}) do
    [[b, c], [e, f]]
  end

  def submatrix([[a, _b, c], [d, _e, f], _], {2, 1}) do
    [[a, c], [d, f]]
  end

  def submatrix([[a, b, _c], [d, e, _f], _], {2, 2}) do
    [[a, b], [d, e]]
  end
end
