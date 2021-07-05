package.path = package.path .. ";./lua/stgit-unofficial/?.lua"

require 'busted'
require 'patch_stack'

describe("The neovim stgit plugins test suite", function()
  describe("should be run always", function()

    it("and it should be easy to use", function()
      assert.truthy("Sure is!")
    end)

    it("A new patch stack object should be empty", function()
      obj = patch_stack:new()
      assert.is_true(obj.i == 0)
    end)

    it("Incrementing twice should have the implied effect", function()
      obj = patch_stack:new()
      assert.is_true(obj:getI() == 0)
      obj:addI()
      obj:addI()
      assert.is_true(obj:getI() == 2)
    end)

  end)
end)
