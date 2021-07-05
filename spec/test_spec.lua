package.path = package.path .. ";./lua/stgit-unofficial/?.lua"

require 'busted'
require 'patch_stack'

describe("patch_stack tests: ", function()
    it("creates a new patch stack from existing patches", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch"}

        stack = patch_stack:new{patches = existing_patches}

        assert.is_true(table.getn(stack.patches) == 3)
    end)

    it("can be peeked into", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch"}
        expected = "> current patch"

        stack = patch_stack:new{patches = existing_patches}

        assert.are.same(expected, stack:peek())
    end)

    it("can return a view", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch"}
        stack = patch_stack:new{patches = existing_patches}

        assert.are.same(existing_patches, stack:view())
    end)

    it("can stage a pop", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch"}
        expected_patches = { "> first applied patch", "- current patch", "- unapplied patch"}

        stack = patch_stack:new{patches = existing_patches}
        stack:stage_pop()

        assert.are.same(expected_patches, stack:view())
    end)

    it("can return index of top", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch"}
        stack = patch_stack:new{patches = existing_patches}

        assert.are.equal(2, stack:index_top())
    end)

    it("can stage a push", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch"}
        expected_patches = { "+ first applied patch", "+ current patch", "> unapplied patch"}
        stack = patch_stack:new{patches = existing_patches}
        stack:stage_push()

        assert.are.same(expected_patches, stack:view())
    end)

    it("can stage a delete", function()
        existing_patches = {"> current patch", "- unapplied patch"}
        expected_patches = {"> current patch", "D unapplied patch"}

        stack = patch_stack:new{patches = existing_patches}
        stack:stage_delete(2)

        assert.are.same(expected_patches, stack:view())
    end)

    it("can stage a delete on current top", function()
        existing_patches = { "+ first applied patch", "> current patch", "- unapplied patch" }
        expected_patches = { "> first applied patch", "D current patch", "- unapplied patch" }

        stack = patch_stack:new{patches = existing_patches}
        stack:stage_delete(2)

        assert.are.same(expected_patches, stack:view())
    end)
end)
