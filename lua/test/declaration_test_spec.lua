require("plenary.test_harness")
local eq = assert.are.same
local utils = require("test.utils")

utils.initialize_test_nvim_opts()

local autofix = require("auto-fix-return")
autofix.setup({
  enabled = false,
  log_level = vim.log.levels.DEBUG,
})

describe("test functions with body defined", function()
  describe("when a single return is started with cursor at the end of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() i {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe(
    "when a single channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() chan i {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single slice return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() []string| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() []string {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("g", char)
      end)
    end
  )

  describe(
    "when a single interface with one space return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface {}| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() interface {} {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("}", char)
      end)
    end
  )

  describe(
    "when a single interface with three spaces return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface   {}| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() interface   {} {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("}", char)
      end)
    end
  )

  describe(
    "when a single send only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan<- i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() chan<- i {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single receive only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() <-chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() <-chan i {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single named channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() c chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (c chan i) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single named send only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() c chan<- i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (c chan<- i) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single named recieve only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() c <-chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (c <-chan i) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe("when a single return has parenthesis ", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() (i|) {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() i {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a single closure return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func() i| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() func() i {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the comma", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func() i,| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (func() i,) {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(",", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func() i, func() k| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (func() i, func() k) {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a single closure with arguments return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func(int) string| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() func(int) string {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("g", char)
    end)
  end)

  describe(
    "when a multi closure with arguments return with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() func(int,| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() func(int, {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi closure with arguments return with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() func(int, string) error,| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (func(int, string) error,) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi closure with arguments return with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid =
          utils.set_test_window_value("func Foo() func(context.Context) error, func(int) bool| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (func(context.Context) error, func(int) bool) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("l", char)
      end)
    end
  )

  describe("when a closure with multiple returns with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func(int) (string, error)| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() func(int) (string, error) {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(")", char)
    end)
  end)

  describe("when a single return has no name and a valid return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func |() i {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not touch anything", function()
      local lines = utils.get_win_lines(winid)
      eq("func () i {}", lines[1])
    end)

    it("should keep the cursor on the i", function()
      local char = utils.get_cursor_char(winid)
      eq(" ", char)
    end)
  end)

  describe(
    "when a single return with comma has an invalid proceeding type definition with cursor in return definition",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func Foo() i,| {}", "", "type foo" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it(
        "should not add parentheses around the return type as the fix parse contains errors and we are not sure it is safe",
        function()
          local lines = utils.get_win_lines(winid)
          local expected = {
            "func Foo() i, {}",
            "",
            "type foo",
          }
          eq(expected, lines)
        end
      )

      it("should make sure the cursor stays in front of the comma", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a single return with comma has an invalid proceeding type definition with cursor in invalid type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func Foo() i, {}", "", "type f|oo" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func Foo() i, {}",
          "",
          "type foo",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("f", char)
      end)
    end
  )

  describe(
    "when a single return with comma has an invalid proceeding type definition with cursor in the function name",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func Fo|o() i, {}", "", "type foo" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func Foo() i, {}",
          "",
          "type foo",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("o", char)
      end)
    end
  )

  describe(
    "when a single return is started with cursor at the end of the first type with a comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() i,| {}")
        vim.cmd("AutoFixReturn")
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (i,) {}", lines[1])
      end)

      it("should set the cursor to inside the parens", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return only has one starting parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() (i,k| {}")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,k) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a multi return only has one ending parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|,k) {}")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,k) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("(", char)
    end)
  end)

  describe("when a multi return is started with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() int, s| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (int, s) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("s", char)
    end)
  end)

  describe(
    "when a multi slice return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() []string,| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() ([]string,) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi slice return is started with cursor at the end of the first type and a proceeding valid declaration",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func Foo() []string,| {}",
          "func bar() {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func Foo() ([]string,) {}",
          "func bar() {}",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when there are multiple functions and a multi return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func Foo() i,| {}",
          "func Bar() j {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the first function return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func Foo() (i,) {}",
          "func Bar() j {}",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan i, t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (chan i, t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi channel return with multiple channels is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan i, chan t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (chan i, chan t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi send only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan<- i, t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (chan<- i, t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi recieve only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() <-chan i, t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (<-chan i, t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe("when a multi return exists with cursor at the start of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|nt, s {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (int, s) {}", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi return has parenthesis and only one body brace", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() (i,s) {|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not modify anything", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,s) {", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("{", char)
    end)
  end)

  describe(
    "when a multi inline interface return is started with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface{M() []b},| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (interface{M() []b},) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return exists with cursor not in the return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func F|oo() int, s {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() int, s {}", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("F", char)
    end)
  end)

  describe("when a multi return exists with cursor in the body definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() int, s {|}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() int, s {}", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("{", char)
    end)
  end)
end)

describe("test functions without a body defined", function()
  describe("when a single return is started with cursor at the end of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() i", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a single return has parenthesis", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() (i|)")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should remove parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() i", lines[1])
    end)

    it("should keep the cursor on the i", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a single return has no name and a valid return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func |() i")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not touch anything", function()
      local lines = utils.get_win_lines(winid)
      eq("func () i", lines[1])
    end)

    it("should keep the cursor on the i", function()
      local char = utils.get_cursor_char(winid)
      eq(" ", char)
    end)
  end)

  describe("when a single closure return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func() i|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() func() i", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the comma", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func() i,|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (func() i,)", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(",", char)
    end)
  end)

  describe("when a multi return only has one starting parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() (i,k|")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,k)", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a multi return only has one ending parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|,k) {}")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,k) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("(", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func() i, func() k|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (func() i, func() k)", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a single closure with arguments return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func(int) string|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() func(int) string", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("g", char)
    end)
  end)

  describe(
    "when a multi closure with arguments return with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() func(int, string) error,|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (func(int, string) error,)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi closure with arguments return with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid =
          utils.set_test_window_value("func Foo() func(context.Context) error, func(int) bool|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (func(context.Context) error, func(int) bool)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("l", char)
      end)
    end
  )

  describe("when a closure with multiple returns with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() func(int) (string, error)|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() func(int) (string, error)", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(")", char)
    end)
  end)

  describe(
    "when a single return with comma has an valid preceding type definition with cursor in return definition",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func Foo() i {}", "", "func Bar() i,|" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func Foo() i {}",
          "",
          "func Bar() (i,)",
        }
        eq(expected, lines)
      end)

      it("should make sure the cursor stays in front of the comma", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi return is started with cursor at the end of the first type with a comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() i,|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type and comma", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (i,)", lines[1])
      end)

      it("should set the cursor to inside the parens", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return is started with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() int, s|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (int, s)", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("s", char)
    end)
  end)

  describe(
    "when a single interface with one space return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface {}|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() interface {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("}", char)
      end)
    end
  )

  describe(
    "when a single interface with one space and nested brackets return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface { { } }|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() interface { { } }", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("}", char)
      end)
    end
  )

  describe(
    "when a single list of interface with one space and nested brackets return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() string[ interface { } ]|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() string[ interface { } ]", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("]", char)
      end)
    end
  )

  describe(
    "when a single interface with three spaces return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface   {}|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() interface   {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("}", char)
      end)
    end
  )

  describe(
    "when a single inline interface return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface{M() []b}|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() interface{M() []b}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("}", char)
      end)
    end
  )

  describe(
    "when there are multiple functions and a multi return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func Foo() i,|",
          "func Bar() j {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the first function return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func Foo() (i,)",
          "func Bar() j {}",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return exists with cursor at the start of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|nt, s")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (int, s)", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi return exists with cursor not in the return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func F|oo() int, s")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() int, s", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("F", char)
    end)
  end)

  describe(
    "when a multi channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan i, t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (chan i, t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi channel return with multiple channels is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan i, chan t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (chan i, chan t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi send only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() chan<- i, t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (chan<- i, t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi recieve only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() <-chan i, t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (<-chan i, t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi slice return is started with cursor at the end of the comma and a proceeding valid declaration",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func foo() []string,|",
          "func bar() {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it(
        "should not add parentheses around the return type as the parse tree is completely broken at this point",
        function()
          local lines = utils.get_win_lines(winid)
          local expected = {
            "func foo() []string,",
            "func bar() {}",
          }
          eq(expected, lines)
        end
      )

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi slice return is started with cursor at the end of the second type and a proceeding valid declaration",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func foo() []string, t|",
          "func bar() {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func foo() ([]string, t)",
          "func bar() {}",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi inline interface return is started with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func Foo() interface{M() []b},|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func Foo() (interface{M() []b},)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )
end)

describe("test methods with body defined", function()
  describe("when a single return is started with cursor at the end of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() i| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() i {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe(
    "when a single channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() chan i {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single send only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan<- i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() chan<- i {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single recieve only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() <-chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() <-chan i {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single named channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() c chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (c chan i) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single named send only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() c chan<- i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (c chan<- i) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe(
    "when a single named recieve only channel return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() c <-chan i| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (c <-chan i) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("i", char)
      end)
    end
  )

  describe("when a single return has parenthesis ", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() (i|) {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() i {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a single return has no name and a valid return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func |() i {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not touch anything", function()
      local lines = utils.get_win_lines(winid)
      eq("func () i {}", lines[1])
    end)

    it("should keep the cursor on the i", function()
      local char = utils.get_cursor_char(winid)
      eq(" ", char)
    end)
  end)

  describe("when a single closure return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func() i| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() func() i {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the comma", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func() i,| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (func() i,) {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(",", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func() i, func() k| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (func() i, func() k) {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a single closure with arguments return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func(int) string| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() func(int) string {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("g", char)
    end)
  end)

  describe(
    "when a multi closure with arguments return with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() func(int, string) error,| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (func(int, string) error,) {}", lines[1])
      end)

      it("should set cursor to the comma", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi closure with arguments return with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value(
          "func (b *Bar) Foo() func(context.Context) error, func(int) bool| {}"
        )
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (func(context.Context) error, func(int) bool) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("l", char)
      end)
    end
  )

  describe("when a closure with multiple returns with arguments with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func(int) (string, error)| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() func(int) (string, error) {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(")", char)
    end)
  end)

  describe(
    "when a single return with comma has an invalid proceeding type definition with cursor in return definition",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func (b *Bar) Foo() i,| {}", "", "type foo" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it(
        "should not add parentheses around the return type as the fix parse contains errors and we are not sure it is safe",
        function()
          local lines = utils.get_win_lines(winid)
          local expected = {
            "func (b *Bar) Foo() i, {}",
            "",
            "type foo",
          }
          eq(expected, lines)
        end
      )

      it("should make sure the cursor stays in front of the comma", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a single return with comma has an invalid proceeding type definition with cursor in invalid type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func (b *Bar) Foo() i, {}", "", "type f|oo" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func (b *Bar) Foo() i, {}",
          "",
          "type foo",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("f", char)
      end)
    end
  )

  describe(
    "when a single return with comma has an invalid proceeding type definition with cursor in the function name",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func (b *Bar) Fo|o() i, {}", "", "type foo" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func (b *Bar) Foo() i, {}",
          "",
          "type foo",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("o", char)
      end)
    end
  )

  describe(
    "when a single return is started with cursor at the end of the first type with a comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() i,| {}")
        vim.cmd("AutoFixReturn")
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (i,) {}", lines[1])
      end)

      it("should set the cursor to inside the parens", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return is started with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() int, s| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (int, s) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("s", char)
    end)
  end)

  describe(
    "when a multi channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan i, t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (chan i, t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi channel return with multiple channels is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan i, chan t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (chan i, chan t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi send only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan<- i, t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (chan<- i, t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi recieve only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() <-chan i, t| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (<-chan i, t) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe("when a multi return exists with cursor at the start of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() i|nt, s {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (int, s) {}", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi return has parenthesis and only one body brace", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() (i,s) {|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not modify anything", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (i,s) {", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("{", char)
    end)
  end)

  describe("when a multi return exists with cursor not in the return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) F|oo() int, s {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() int, s {}", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("F", char)
    end)
  end)

  describe("when a multi return only has one starting parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() (i,k| {}")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (i,k) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a multi return only has one ending parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|,k) {}")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,k) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("(", char)
    end)
  end)

  describe(
    "when a multi inline interface return is started with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (s *string) Foo() interface{M() []b},| {}")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (s *string) Foo() (interface{M() []b},) {}", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return exists with cursor in the body definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() int, s {|}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() int, s {}", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("{", char)
    end)
  end)
end)

describe("test methods without a body defined", function()
  describe("when a single return is started with cursor at the end of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() i|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() i", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a single return has parenthesis", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() (i|)")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should remove parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() i", lines[1])
    end)

    it("should keep the cursor on the i", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a single return has no name and a valid return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func |() i")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not touch anything", function()
      local lines = utils.get_win_lines(winid)
      eq("func () i", lines[1])
    end)

    it("should keep the cursor on the i", function()
      local char = utils.get_cursor_char(winid)
      eq(" ", char)
    end)
  end)

  describe("when a single closure return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func() i|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() func() i", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the comma", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func() i,|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (func() i,)", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(",", char)
    end)
  end)

  describe("when a multi closure return with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func() i, func() k|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (func() i, func() k)", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a single closure with arguments return with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func(int) string|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() func(int) string", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("g", char)
    end)
  end)

  describe(
    "when a multi closure with arguments return with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() func(int, string) error,|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (func(int, string) error,)", lines[1])
      end)

      it("should set cursor to the comma", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi closure with arguments return with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value(
          "func (b *Bar) Foo() func(context.Context) error, func(int) bool|"
        )
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (func(context.Context) error, func(int) bool)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("l", char)
      end)
    end
  )

  describe("when a closure with multiple returns with arguments with cursor at the end", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() func(int) (string, error)|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() func(int) (string, error)", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq(")", char)
    end)
  end)

  describe(
    "when a single return with comma has an valid preceeding type definition with cursor in return definition",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({ "func (b *Bar) Foo() i {}", "", "func Bar() i,|" })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func (b *Bar) Foo() i {}",
          "",
          "func Bar() (i,)",
        }
        eq(expected, lines)
      end)

      it("should make sure the cursor stays in front of the comma", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi return is started with cursor at the end of the first type with a comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() i,|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type and comma", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (i,)", lines[1])
      end)

      it("should set the cursor to inside the parens", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe("when a multi return is started with cursor at the end of the second type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() int, s|")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (int, s)", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("s", char)
    end)
  end)

  describe("when a multi return exists with cursor at the start of the first type", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() i|nt, s")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (int, s)", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("i", char)
    end)
  end)

  describe("when a multi return exists with cursor not in the return definition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) F|oo() int, s")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() int, s", lines[1])
    end)

    it("not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("F", char)
    end)
  end)

  describe(
    "when there are multiple methods and a multi return is started with cursor at the end of the first type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func (s *string) Foo() i,|",
          "func (s *string) Bar() j {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the first function return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func (s *string) Foo() (i,)",
          "func (s *string) Bar() j {}",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan i, t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (chan i, t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi slice return is started with cursor at the end of the second type and a proceeding valid declaration",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value({
          "func (s *string) foo() []string, t|",
          "func (s *string) bar() {}",
        })
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        local expected = {
          "func (s *string) foo() ([]string, t)",
          "func (s *string) bar() {}",
        }
        eq(expected, lines)
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi channel return with multiple channels is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan i, chan t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (chan i, chan t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe("when a multi return only has one starting parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func (b *Bar) Foo() (i,k|")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func (b *Bar) Foo() (i,k)", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("k", char)
    end)
  end)

  describe("when a multi return only has one ending parentheses", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func Foo() i|,k) {}")
      vim.cmd("AutoFixReturn")
    end)

    it("should add parentheses around the return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func Foo() (i,k) {}", lines[1])
    end)

    it("should set the cursor to inside the parens", function()
      local char = utils.get_cursor_char(winid)
      eq("(", char)
    end)
  end)

  describe(
    "when a multi send only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() chan<- i, t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (chan<- i, t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )

  describe(
    "when a multi inline interface return is started with cursor at the end of the comma",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (s *string) Foo() interface{M() []b},|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (s *string) Foo() (interface{M() []b},)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq(",", char)
      end)
    end
  )

  describe(
    "when a multi recieve only channel return is started with cursor at the end of the second type",
    function()
      local winid = 0
      before_each(function()
        winid = utils.set_test_window_value("func (b *Bar) Foo() <-chan i, t|")
        vim.cmd("AutoFixReturn")
      end)

      after_each(function()
        utils.cleanup_test(winid)
      end)

      it("should not add parentheses around the return type", function()
        local lines = utils.get_win_lines(winid)
        eq("func (b *Bar) Foo() (<-chan i, t)", lines[1])
      end)

      it("should not touch the cursor", function()
        local char = utils.get_cursor_char(winid)
        eq("t", char)
      end)
    end
  )
end)

describe("test non function syntax constructs", function()
  describe("when editing a for loop initialization", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value({
        "package main",
        "",
        'import "fmt"',
        "",
        "func main() {",
        "  for i:=0|;i<10;i++{",
        '    fmt.Println("Hello")',
        "  }",
        "}",
      })
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not modify the code", function()
      local lines = utils.get_win_lines(winid)
      local expected = {
        "package main",
        "",
        'import "fmt"',
        "",
        "func main() {",
        "  for i:=0;i<10;i++{",
        '    fmt.Println("Hello")',
        "  }",
        "}",
      }
      eq(expected, lines)
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("0", char)
    end)
  end)

  describe("when editing a for loop condition", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value({
        "package main",
        "",
        'import "fmt"',
        "",
        "func main() {",
        "  for i:=0;i<1|0;i++{",
        '    fmt.Println("Hello")',
        "  }",
        "}",
      })
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not modify the code", function()
      local lines = utils.get_win_lines(winid)
      local expected = {
        "package main",
        "",
        'import "fmt"',
        "",
        "func main() {",
        "  for i:=0;i<10;i++{",
        '    fmt.Println("Hello")',
        "  }",
        "}",
      }
      eq(expected, lines)
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("1", char)
    end)
  end)

  describe("when a single generic return type with multiple type parameters", function()
    local winid = 0
    before_each(function()
      winid = utils.set_test_window_value("func foo() foo.bar[T, V]| {}")
      vim.cmd("AutoFixReturn")
    end)

    after_each(function()
      utils.cleanup_test(winid)
    end)

    it("should not add parentheses around the generic return type", function()
      local lines = utils.get_win_lines(winid)
      eq("func foo() foo.bar[T, V] {}", lines[1])
    end)

    it("should not touch the cursor", function()
      local char = utils.get_cursor_char(winid)
      eq("]", char)
    end)
  end)
end)
