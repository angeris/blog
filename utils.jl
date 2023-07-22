function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function hfun_page_titles(; dirname="content")
    c = IOBuffer()

    pages = filter(!isdir, joinpath.(dirname, readdir(dirname)))

    getdate(p) = pagevar(p, "date")

    sort!(pages, by=getdate, rev=true)
    write(c, "<ul class=\"post-list\">")

    for p in pages
        if pagevar(p, "draft"; default=false)
            continue
        end
        title = pagevar(p, "title")
        date = getdate(p)
        url = get_url(p)
        write(c, "<li><a href=\"$url\">$title</a> <label>($(string(date)))</label></li>\n")
    end

    write(c, "</ul>")

    return String(take!(c))
end
