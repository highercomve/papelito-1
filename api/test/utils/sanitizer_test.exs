defmodule Papelito.Utils.SanitizerTest do
  use ExUnit.Case

  test "Remove accents chars" do
    assert Papelito.Utils.Sanitizer.clean("Hubert Łępicki") == "hubert_epicki"
    assert Papelito.Utils.Sanitizer.clean("árboles más grandes") == "arboles_mas_grandes"
    assert Papelito.Utils.Sanitizer.clean("Übel wütet der Gürtelwürger") == "ubel_wutet_der_gurtelwurger"
  end

end
