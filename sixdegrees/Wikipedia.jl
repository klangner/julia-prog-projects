module Wikipedia

using HTTP, Gumbo, Cascadia

export fetchrandom, fetchpage, articlelinks

const PROTOCOL = "https://"
const DOMAIN_NAME = "en.m.wikipedia.org"
const RANDOM_PAGE_URL = PROTOCOL * DOMAIN_NAME * "/wiki/Special:Random"

function fetchpage(url)
  response = buildurl(url) |> HTTP.get
  if response.status == 200 && length(response.body) > 0
    String(response.body)
  else
    ""
  end
end

function extractlinks(elem)
  map(eachmatch(Selector("a[href^='/wiki/']:not(a[href*=':'])"), elem)) do e
    e.attributes["href"]
  end |> unique
end

function fetchrandom()
  fetchpage(RANDOM_PAGE_URL)
end

function articlelinks(content)
  if ! isempty(content)
    dom = Gumbo.parsehtml(content)
    links = extractlinks(dom.root)
  end
end

function buildurl(url)
  if startswiths(url, "/")
    PROTOCOL * DOMAIN_NAME * URL
  else
    url
  end
end

end
