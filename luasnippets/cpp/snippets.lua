--- Provides snippets for C++.

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
if not ts_utils_ok then return {} end

local cpp_classes = vim.treesitter.query.parse(
  "cpp",
  [[
    [
        (struct_specifier name: [((type_identifier) @name) (template_type name: (type_identifier) @name)])
        (class_specifier name: [((type_identifier) @name) (template_type name: (type_identifier) @name)])
    ] @class
]]
)

--- Returns list of all C++ classes or structs in the language tree that contains a given line.
-- @param linenr Line number that will be used to get the language tree.
-- @return List of tuples (line begin, line end, class name). Lines use inclusive 1-indexing.
local function list_classes(linenr)
  local bufnr = vim.api.nvim_get_current_buf()

  local root = ts_utils.get_root_for_position(linenr - 1, 0)
  if not root then return {} end

  local result = {}

  for _, captures, _ in cpp_classes:iter_matches(root, bufnr) do
    local lbegin, _, lend, _ = ts_utils.get_vim_range { captures[2]:range() }
    local name = query.get_node_text(captures[1], bufnr)
    table.insert(result, { lbegin, lend, name })
  end

  return result
end

--- Gets name of the surrounding C++ class.
-- @param linenr Line number to use.
-- @return Name of the surrounding class or nil if none was found.
local function get_surrounding_class(linenr)
  local classes = list_classes(linenr)
  local min_range
  local min_name

  for _, class_info in pairs(classes) do
    local lbegin, lend, name = unpack(class_info)

    if lbegin <= linenr and lend >= linenr and (not min_range or lend - lbegin < min_range) then
      min_range = lend - lbegin
      min_name = name
    end
  end

  return min_name
end

return {
  s("for", {
    t "for (",
    c(1, {
      sn(nil, {
        t "std::size_t ",
        i(1, "i"),
        t " = ",
        i(2, "0"),
        t "; ",
        rep(1),
        t " < ",
        i(3, "n"),
        t "; ",
        rep(1),
      }),
      sn(nil, { t "const auto& ", r(1, "elem"), t " : ", r(2, "range") }),
      sn(nil, { t "auto&& ", r(1, "elem"), t " : ", r(2, "range") }),
    }),
    t { ") {", "\t" },
    i(0),
    t { "", "}" },
  }, { stored = { elem = i(1, "elem"), range = i(2, "range") } }),
  parse("while", "while (${1:cond}) {\n\t$0\n}"),
  parse("do", "do {\n\t$0\n} while (${1:cond});"),
  s("if", {
    t "if (",
    c(1, {
      r(1, "cond"),
      sn(nil, { i(1, "init"), t "; ", r(2, "cond") }),
    }),
    t { ") {", "\t" },
    i(0),
    t { "", "}" },
  }, { stored = { cond = i(1, "cond") } }),
  s("ifc", {
    t "if constexpr (",
    c(1, {
      r(1, "cond"),
      sn(nil, { i(1, "init"), t "; ", r(2, "cond") }),
    }),
    t { ") {", "\t" },
    i(0),
    t { "", "}" },
  }, { stored = { cond = i(1, "cond") } }),
  parse("e", "else {\n\t$0\n}"),
  parse("ei", "else if ($1) {\n\t$0\n}"),
  parse("eic", "else if constexpr ($1) {\n\t$0\n}"),

  -- Standard library types / containers
  parse("vec", "std::vector<${1:T}>"),
  parse("map", "std::unordered_map<${1:Key}, ${2:Value}>"),
  parse("imap", "std::map<${1:Key}, ${2:Value}>"),
  parse("str", "std::string"),
  parse("up", "std:unique_ptr<${1:T}>"),
  parse("sp", "std:shared_ptr<${1:T}>"),

  -- Attributes
  parse("nd", "[[nodiscard]]"),

  -- Special member declarations
  s("consd", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
      assert(cname, "Could not get surrounding class!")
      return sn(nil, { t(cname), t "(", i(1), t ");" })
    end),
  }),
  s("cconsd", {
    f(function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
      assert(cname, "Could not get surrounding class!")
      return cname .. "(" .. cname .. " const& other);"
    end),
  }),
  s("mconsd", {
    f(function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
      assert(cname, "Could not get surrounding class!")
      return cname .. "(" .. cname .. "&& other) noexcept;"
    end),
  }),
  s("cassd", {
    f(function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
      assert(cname, "Could not get surrounding class!")
      return cname .. "& operator=(" .. cname .. " const& other);"
    end),
  }),
  s("massd", {
    f(function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
      assert(cname, "Could not get surrounding class!")
      return cname .. "& operator=(" .. cname .. "&& other) noexcept;"
    end),
  }),
  s("desd", {
    f(function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
      assert(cname, "Could not get surrounding class!")
      return "~" .. cname .. "();"
    end),
  }),

  -- Special member definitions
  s("consi", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

      if cname then
        return sn(nil, { t(cname .. "("), i(1), t ")", n(2, " : "), i(2), t { " {", "\t" }, i(3), t { "", "}" } })
      else
        return sn(nil, {
          i(1, "Class"),
          t "::",
          rep(1),
          t "(",
          i(2),
          t ")",
          n(3, " : "),
          i(3),
          t { " {", "\t" },
          i(4),
          t { "", "}" },
        })
      end
    end),
  }),
  s("cconsi", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

      if cname then
        return sn(nil, { t { cname .. "(" .. cname .. " const& other) {", "\t" }, i(1), t { "", "}" } })
      else
        return sn(nil, {
          i(1, "Class"),
          t "::",
          l(l._1:match "([^<]*)", 1),
          t "(",
          l(l._1:match "([^<]*)", 1),
          t { " const& other) {", "\t" },
          i(2),
          t { "", "}" },
        })
      end
    end),
  }),
  s("mconsi", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

      if cname then
        return sn(nil, { t { cname .. "(" .. cname .. "&& other) noexcept {", "\t" }, i(1), t { "", "}" } })
      else
        return sn(nil, {
          i(1, "Class"),
          t "::",
          l(l._1:match "([^<]*)", 1),
          t "(",
          l(l._1:match "([^<]*)", 1),
          t { "&& other) noexcept {", "\t" },
          i(2),
          t { "", "}" },
        })
      end
    end),
  }),
  s("cassi", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

      if cname then
        return sn(
          nil,
          { t { cname .. "& operator=(" .. cname .. " const& other) {", "\t" }, i(1), t { "", "\treturn *this;", "}" } }
        )
      else
        return sn(nil, {
          i(1, "Class"),
          t "& ",
          rep(1),
          t "::operator=(",
          l(l._1:match "([^<*])", 1),
          t { " const& other) {", "\t" },
          i(2),
          t { "", "\treturn *this;", "}" },
        })
      end
    end),
  }),
  s("massi", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

      if cname then
        return sn(nil, {
          t { cname .. "& operator=(" .. cname .. "&& other) noexcept {", "\t" },
          i(1),
          t { "", "\treturn *this;", "}" },
        })
      else
        return sn(nil, {
          i(1, "Class"),
          t "& ",
          rep(1),
          t "::operator=(",
          l(l._1:match "([^<]*)", 1),
          t { "&& other) noexcept {", "\t" },
          i(2),
          t { "", "\treturn *this;", "}" },
        })
      end
    end),
  }),
  s("desi", {
    d(1, function(_, snip)
      local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

      if cname then
        return sn(nil, { t { "~" .. cname .. "() {", "\t" }, i(1), t { "", "}" } })
      else
        return sn(nil, { i(1, "Class"), t "::~", l(l._1:match "([^<]*)", 1), t { "() {", "\t" }, i(2), t { "", "}" } })
      end
    end),
  }),

  -- Other
  parse("ip", "${1:range}.begin(), $1.end()"),
  parse("print", "std::cout << $1 << '\\n';"),
  s("bind", {
    c(1, {
      sn(nil, { t "auto const& [", r(1, "bindings"), t "] = ", r(2, "value"), t ";" }),
      sn(nil, { t "auto&& [", r(1, "bindings"), t "] = ", r(2, "value"), t ";" }),
    }),
  }, { stored = { bindings = i(1, "bindings"), value = i(2, "value") } }),
  s("main", {
    t "int main(",
    c(1, {
      t "",
      t "int const argc, char const* const* const argv",
    }),
    t { ") {", "\t" },
    i(0),
    t { "", "}" },
  }),
  s("inc", {
    t "#include ",
    c(1, {
      sn(nil, { t "<", r(1, "header"), t ">" }),
      sn(nil, { t '"', r(1, "header"), t '"' }),
    }),
  }, { stored = { header = i(1, "header") } }),
  parse("cinit", "auto const $1 = [&] {\n\t$0\n}();"),
}
