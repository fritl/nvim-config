-- :DBERD [schema] — generate a Mermaid ER diagram from the current
-- PostgreSQL connection and open it in the browser.
--
-- Static snapshot: re-run the command after schema changes. Needs the `psql`
-- CLI and internet access for the Mermaid CDN in the generated HTML.

local ERD_DIR = vim.fn.stdpath("data") .. "/erd"

--- Sanitize an identifier for use as a mermaid entity/attribute name
local function ident(s)
	s = s:gsub("%s+", "_"):gsub("[^%w_]", "_"):gsub("_+", "_"):gsub("^_+", ""):gsub("_+$", "")
	return s:upper()
end

local function db_name_from_url(url)
	local name = url:match("[^/]+$") or "database"
	name = name:match("^[^?]+") or name
	return name ~= "" and name or "database"
end

local function pick_url(cb)
	local url = vim.b.db or vim.g.db
	if url and url ~= "" then
		cb(url)
		return
	end
	local dbs = vim.g.dbs or {}
	if vim.tbl_isempty(dbs) then
		vim.notify(
			"DBERD: no connection available — set one with <leader>dc, :DB <url>, or via lua/dbs.lua",
			vim.log.levels.WARN
		)
		return
	end
	vim.ui.select(dbs, {
		prompt = "DBERD: database",
		format_item = function(item)
			return item.name
		end,
	}, function(choice)
		if choice then
			cb(choice.url)
		end
	end)
end

--- Run one psql query, cb(rows) with rows as list of field lists
local function query(url, sql, cb)
	vim.system({ "psql", url, "-A", "-t", "-F", "|", "-c", sql }, {
		env = { PGCONNECT_TIMEOUT = "10" },
		text = true,
	}, function(res)
		-- schedule: the on_exit callback runs in a fast event context where
		-- nvim_* API calls (notify, writefile, …) are not allowed
		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify(
					"DBERD: psql failed: " .. vim.trim((res.stderr or "") ~= "" and res.stderr or (res.stdout or "")),
					vim.log.levels.ERROR
				)
				cb(nil)
				return
			end
			local rows = {}
			for _, line in ipairs(vim.split(vim.trim(res.stdout or ""), "\n")) do
				local fields = vim.split(line, "|", { plain = true })
				if #fields > 0 and fields[1] ~= "" then
					table.insert(rows, fields)
				end
			end
			cb(rows)
		end)
	end)
end

--- Resolves the default schema from the connection's search_path
local function default_schema(url, cb)
	query(url, "SELECT current_schema();", function(rows)
		cb(rows and rows[1] and rows[1][1] or "public")
	end)
end

--- List user schemas, cb(list_of_names)
local function user_schemas(url, cb)
	query(
		url,
		"SELECT nspname FROM pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname <> 'information_schema' ORDER BY nspname;",
		function(rows)
			local names = {}
			for _, r in ipairs(rows or {}) do
				table.insert(names, r[1])
			end
			cb(names)
		end
	)
end

--- Run all schema queries, cb(tables, columns, pk, fk)
local function fetch_schema(url, schema, cb)
	local safe = schema:gsub("[^%w_$]", "")

	local tables_sql = string.format(
		"SELECT table_name FROM information_schema.tables WHERE table_schema = '%s' AND table_type = 'BASE TABLE' ORDER BY table_name;",
		safe
	)
	local columns_sql = string.format(
		"SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_schema = '%s' ORDER BY table_name, ordinal_position;",
		safe
	)
	local pk_sql = string.format(
		"SELECT tc.table_name, kcu.column_name FROM information_schema.table_constraints tc "
			.. "JOIN information_schema.key_column_usage kcu ON kcu.constraint_name = tc.constraint_name AND kcu.table_schema = tc.table_schema "
			.. "WHERE tc.constraint_type = 'PRIMARY KEY' AND tc.table_schema = '%s' ORDER BY tc.table_name;",
		safe
	)
	-- FK rows are paired positionally: the referencing side comes from
	-- key_column_usage, the referenced side from the unique constraint
	-- that backs the FK (via referential_constraints)
	local fk_sql = string.format(
		[[
WITH fks AS (
  SELECT tc.constraint_name, tc.table_name AS fk_table,
         kcu.column_name AS fk_column, kcu.ordinal_position AS pos
  FROM information_schema.table_constraints tc
  JOIN information_schema.key_column_usage kcu
    ON kcu.constraint_name = tc.constraint_name AND kcu.table_schema = tc.table_schema
  WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_schema = '%s'
),
refs AS (
  SELECT rc.constraint_name AS fkc_name, tc.table_name AS ref_table,
         kcu.column_name AS ref_column, kcu.ordinal_position AS pos
  FROM information_schema.referential_constraints rc
  JOIN information_schema.table_constraints tc
    ON tc.constraint_name = rc.unique_constraint_name AND tc.table_schema = '%s'
  JOIN information_schema.key_column_usage kcu
    ON kcu.constraint_name = tc.constraint_name AND kcu.table_schema = tc.table_schema
)
SELECT fk_table, fk_column, ref_table, ref_column, fks.pos, fks.constraint_name
FROM fks JOIN refs ON refs.fkc_name = fks.constraint_name AND refs.pos = fks.pos
ORDER BY fks.constraint_name, pos;]],
		safe,
		safe
	)

	local out = {}
	local steps = { { tables_sql, "tables" }, { columns_sql, "columns" }, { pk_sql, "pk" }, { fk_sql, "fk" } }

	local run
	run = function(i)
		if i > #steps then
			cb(out.tables, out.columns, out.pk, out.fk)
			return
		end
		query(url, steps[i][1], function(rows)
			if not rows then
				cb(nil, nil, nil, nil)
				return
			end
			out[steps[i][2]] = rows
			run(i + 1)
		end)
	end
	run(1)
end

local function build_mermaid(tables, columns, pk, fk)
	-- pk / fk lookups
	local is_pk, is_fk = {}, {}
	for _, r in ipairs(pk or {}) do
		is_pk[r[1] .. "\x1f" .. r[2]] = true
	end
	for _, r in ipairs(fk or {}) do
		is_fk[r[1] .. "\x1f" .. r[2]] = true
	end

	-- columns grouped per table
	local cols_by_table = {}
	for _, r in ipairs(columns or {}) do
		cols_by_table[r[1]] = cols_by_table[r[1]] or {}
		local list = cols_by_table[r[1]]
		list[#list + 1] = { r[2], r[3] } -- { column_name, data_type }
	end

	local lines = { "erDiagram" }

	-- entities: one block per declared table
	for _, row in ipairs(tables or {}) do
		local t = row[1] -- psql rows come back as { table_name }
		lines[#lines + 1] = "    " .. ident(t) .. " {"
		for _, col in ipairs(cols_by_table[t] or {}) do
			-- mermaid attribute order: type name [PK|FK]
			local attr = ident(col[2]) .. " " .. ident(col[1])
			if is_pk[t .. "\x1f" .. col[1]] then
				attr = attr .. " PK"
			elseif is_fk[t .. "\x1f" .. col[1]] then
				attr = attr .. " FK"
			end
			lines[#lines + 1] = "        " .. attr
		end
		lines[#lines + 1] = "    }"
	end

	-- edges: referenced (one) side first: REF ||--o{ FK_TABLE
	local edges, order = {}, {}
	for _, r in ipairs(fk or {}) do
		local key = r[3] .. "\x1f" .. r[1]
		if not edges[key] then
			edges[key] = { ref = r[3], fk = r[1], labels = {} }
			order[#order + 1] = key
		end
		table.insert(edges[key].labels, r[2] .. " -> " .. r[4])
	end
	for _, key in ipairs(order) do
		local e = edges[key]
		lines[#lines + 1] = "    " .. ident(e.ref) .. " ||--o{ " .. ident(e.fk) .. ' : "' .. table.concat(e.labels, ", ") .. '"'
	end

	return table.concat(lines, "\n")
end

local function write_and_open(db, schema, mmd)
	local html = [=[
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>%s — %s</title></head>
  <body>
    <pre class="mermaid">
%s
    </pre>
    <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        if (!window.mermaid) {
          document.body.innerHTML =
            "<h3>Mermaid library could not be loaded (offline?)</h3>" +
            "<p>Render the diagram with any mermaid renderer, or use the .mmd file next to this one.</p>";
          return;
        }
        mermaid.initialize({ startOnLoad: true, securityLevel: "loose" });
      });
    </script>
  </body>
</html>
]=]
	html = string.format(html, db, schema, mmd)

	vim.fn.mkdir(ERD_DIR, "p")
	local base = ERD_DIR .. "/" .. db
	local html_path, mmd_path = base .. ".html", base .. ".mmd"
	vim.fn.writefile(vim.split(html, "\n"), html_path)
	vim.fn.writefile(vim.split(mmd, "\n"), mmd_path)
	vim.system({ "xdg-open", html_path }, { detach = true })
	vim.notify(("ER diagram written to %s (raw .mmd alongside for offline rendering)"):format(html_path))
end

vim.api.nvim_create_user_command("DBERD", function(opts)
	local function run(schema)
		pick_url(function(url)
			local db = db_name_from_url(url)
			vim.notify("DBERD: querying schema '" .. schema .. "' from " .. db .. "…")
			fetch_schema(url, schema, function(tables, columns, pk, fk)
				if not tables then
					return
				end
				if #tables == 0 then
					-- Empty schema: report which schemas exist so the user
					-- knows what to pass. Most common lesson pitfall: the
					-- tables live in a non-public schema.
					user_schemas(url, function(names)
						if #names == 0 then
							vim.notify(("DBERD: database '%s' has no schemas with tables (empty database?)"):format(db), vim.log.levels.WARN)
						else
							vim.notify(
								("DBERD: schema '%s' in %s is empty — schemas found: %s. Use :DBERD <schema>.")
									:format(schema, db, table.concat(names, ", ")),
								vim.log.levels.WARN
							)
						end
					end)
					return
				end
				local mmd = build_mermaid(tables, columns, pk, fk)
				write_and_open(db, schema, mmd)
			end)
		end)
	end

	if opts.fargs[1] then
		run(opts.fargs[1])
	else
		pick_url(function(url)
			-- no explicit schema: use the connection's search_path
			default_schema(url, run)
		end)
		return
	end
end, {
	nargs = "?",
	desc = "ER diagram (mermaid) for the current Postgres connection; schema defaults to the connection's search_path",
})
