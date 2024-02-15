function tprint (...)
  for i,v in pairs(...) do
    print(i)
    print(v)
  end
end

ttable = { ok = "not" }
othertable = { ok = "isok" }
tprint ( ttable, othertable )
