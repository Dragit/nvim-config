local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep


-- add snippets here
local js_and_ts_snippets = {
  s("type", {
    t('/** @type {'),
    i(1, 'type'),
    t('} */')
  })
    -- also workds
    -- s("hello", {
    --     t('print("hello '),
    --     i(1),
    --     t(' world")')
    -- }),

    -- further working exapmle
    -- s("if", {
    --     t('if '),
    --     i(1, "true"),
    --     t(' then '),
    --     i(2),
    --     t(' end')
    -- })
}

ls.add_snippets("javascript", js_and_ts_snippets)
-- ls.add_snippets("typesript", js_and_ts_snippets)

-- this doesn't work for some reason
ls.add_snippets("tex", {
    s("beg", {
        t("\\begin{"), i(1), t("}"),
        t({ "", "\t" }), i(0),
        t({ "", "\\end{" }), rep(1), t("}"),
    })
})
