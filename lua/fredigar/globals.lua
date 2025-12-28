function P(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(name)
  package.loaded[name] = nil
  return require(name)
end

R = function(name)
  return RELOAD(name)
end


RM = function()
  vim.cmd('w')
  _G.mymod = RELOAD('journal')
  RELOAD('journal.backend')
  -- RELOAD('journal.frontend')
  _G.mymod.setup()
end
