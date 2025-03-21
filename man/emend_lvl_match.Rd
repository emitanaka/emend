% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/factor.R
\name{emend_lvl_match}
\alias{emend_lvl_match}
\title{Match the input factor to supplied levels.}
\usage{
emend_lvl_match(.f, levels = NULL, chat = get_default_chat())
}
\arguments{
\item{.f}{A vector of characters or a factor.}

\item{levels}{The levels of the factor.}

\item{chat}{The chat object defined by ellmer.}
}
\description{
Match the input factor to supplied levels.
}
\examples{
chat <- ellmer::chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
emend_lvl_match(messy$country,
                levels = c("Asia", "Europe", "North America", "Oceania",
                           "South America"),
                chat = chat)

}
