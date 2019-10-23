using HTTP, Gumbo

const PAGE_URL = "https://en.wikipedia.org/wiki/Julia_(programming_language)"
const LINKS = String[]

function fetchpage(url)
    response = HTTP.get(url)
    headers = Dict(response.headers)
    if response.status == 200 && parse(Int, headers["Content-Length"]) > 0
        String(response.body)
    else
        ""
    end
end

function extractlinks(elem)
    if isa(elem, HTMLElement) && tag(elem) == :a && in("href", collect(keys(attrs(elem))))
        url = getattr(elem, "href")
        if startswith(url, "/wiki/") && ! occursin(":", url)
            push!(LINKS, url)
        end
    end

    for child in children(elem)
        extractlinks(child)
    end
end


content = fetchpage(PAGE_URL)
if !isempty(content)
    dom = Gumbo.parsehtml(content)
    extractlinks(dom.root)
end

println.(unique(LINKS))
