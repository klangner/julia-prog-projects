module Gameplay

using ..Wikipedia

export newgame

const DIFFICULTY_EASY = 2
const DIFFICULTY_MEDIUM = 4
const DIFFICULTY_HARD = 6

function newgame(difficulty = DIFFICULTY_HARD)
  articles = []

  for i in 1:difficulty
    article = if i == 1
      fetchrandom()
    else
      rand(articles[i-1][:links]) |> Wikipedia.fetchpage
    end

    article_data = Dict(:content => article, :links => articlelinks(article))
    push!(articles, article_data)
  end

  articles
end

end
