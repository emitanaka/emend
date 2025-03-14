
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SAI

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Save time and effort by using SAI to clean and standardise your data.
The SAI package is your artificial intelligence (AI) assistant that
contain a collection of functions to help you with your data cleaning
tasks.

WARNING: validate that the method works for your own data context.

The default setting has been set so that the results are reproducible
and less prone to “creativity”, as desired for data processing. The
reproducibility is achieved within the same system (i.e. computer) only
and not necessarily across different systems.

## Installation

### Large Language Model

You will also need to set up a large language model (LLM), either by
downloading a local LLM via Ollama or API access. To do this see
[`vignette("setup-LLM", package = "SAI")`](https://emitanaka.org/SAI/articles/setup-LLM.html).

### Package

You can install the development version of SAI like below:

``` r
# install.packages("pak")
pak::pak("emitanaka/SAI")
```

## Example

``` r
library(SAI)
```

### Correcting order of levels for ordinal variables

The levels of categorical variables by default are ordered
alphabetically. This can be problematic when the levels have a natural
order.

``` r
factor(likerts$likert1)
#>  [1] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#>  [5] Disagree          Somewhat Agree    Strongly Agree    Somewhat Disagree
#>  [9] Agree             Disagree          Somewhat Disagree Somewhat Disagree
#> [13] Strongly Disagree Somewhat Agree    Somewhat Agree    Disagree         
#> [17] Agree             Agree             Disagree          Strongly Agree   
#> [21] Strongly Disagree Strongly Agree    Somewhat Agree    Somewhat Agree   
#> [25] Strongly Disagree Strongly Disagree Agree             Somewhat Agree   
#> [29] Somewhat Agree    Disagree          Disagree          Agree            
#> [33] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#> [37] Neutral           Somewhat Disagree Agree             Disagree         
#> 7 Levels: Agree Disagree Neutral Somewhat Agree ... Strongly Disagree
```

A correct order may need to be manually specified like below, but it can
be a tedious task.

``` r
factor(likerts$likert1, 
       levels = c("Strongly Disagree", "Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Agree", "Strongly Agree")) 
#>  [1] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#>  [5] Disagree          Somewhat Agree    Strongly Agree    Somewhat Disagree
#>  [9] Agree             Disagree          Somewhat Disagree Somewhat Disagree
#> [13] Strongly Disagree Somewhat Agree    Somewhat Agree    Disagree         
#> [17] Agree             Agree             Disagree          Strongly Agree   
#> [21] Strongly Disagree Strongly Agree    Somewhat Agree    Somewhat Agree   
#> [25] Strongly Disagree Strongly Disagree Agree             Somewhat Agree   
#> [29] Somewhat Agree    Disagree          Disagree          Agree            
#> [33] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#> [37] Neutral           Somewhat Disagree Agree             Disagree         
#> 7 Levels: Strongly Disagree Disagree Somewhat Disagree ... Strongly Agree
```

The `sai_fct_reorder()` function will try to reorder the levels of the
factor in a meaningful way *automatically* using a large language model.

``` r
sai_fct_reorder(likerts$likert1) |> levels()
#> [1] "Strongly Disagree" "Disagree"          "Somewhat Disagree"
#> [4] "Neutral"           "Somewhat Agree"    "Agree"            
#> [7] "Strongly Agree"
```

### Specifying the LLM

The default large language model and its parameters are shown below.

``` r
sai_get_option("model")
#> $model
#> [1] "llama3.1:8b"
#> 
#> $vendor
#> [1] "ollama"
#> 
#> $args
#> $args$port
#> [1] 11434
#> 
#> $args$format
#> [1] "none"
#> 
#> $args$tools
#> NULL
#> 
#> $args$temperature
#> [1] 0
#> 
#> $args$stop
#> [1] NA
#> 
#> $args$seed
#> [1] 0
#> 
#> $args$top_k
#> [1] 1
#> 
#> $args$top_p
#> [1] 0.1
#> 
#> $args$num_predict
#> [1] 1000
#> 
#> $args$keep_alive
#> [1] "5m"
```

You can change the model to another one (provided that it is available
in your system) like below:

``` r
sai_set_option("model", model_ollama("llama3.2:1b"))
```

Tiny models (1b) are faster but less accurate. It is not recommended to
use them for important tasks.

### Categorise text

Some categorical variables can have simple typos or alternative
representations. For example below we have “UK” written also as “United
Kingdom”.

``` r
messy$country
#>  [1] "UK"             "US"             "Canada"         "UK"            
#>  [5] "US"             "Canada"         "United Kingdom" "USA"           
#>  [9] "New Zealand"    "NZ"             "Australia"      "New Zealand"   
#> [13] "UK"             "United Kingdom" "UK"             "US"            
#> [17] "United Kingdom" "Australia"      "US"             "Australia"
```

While you can manually fix this, again, this can be tedious. We can map
this automatically using `sai_fct_match()`

``` r
sai_fct_match(messy$country, levels = c("UK", "USA", "Canada", "Australia", "NZ"))
#>  [1] UK        USA       Canada    UK        USA       Canada    UK       
#>  [8] USA       NZ        NZ        Australia NZ        UK        UK       
#> [15] UK        USA       UK        Australia USA       Australia
#> Levels: UK USA Canada Australia NZ
```

The function actually works to match a continent as well! Let’s use
`sai_lvl_match()` to more easily see the conversion on the levels alone.

``` r
sai_lvl_match(messy$country, levels = c("Asia", "Europe", "North America", "Oceania", "South America"))
#>              UK              US          Canada  United Kingdom             USA 
#>        "Europe" "North America" "North America"        "Europe" "North America" 
#>     New Zealand              NZ       Australia 
#>       "Oceania"       "Oceania"       "Oceania"
#> 
#> ── Converted by SAI: ───────────────────────────────────────────────────────────
#>         original     converted
#> 1             UK        Europe
#> 2 United Kingdom        Europe
#> 3             US North America
#> 4         Canada North America
#> 5            USA North America
#> 6    New Zealand       Oceania
#> 7             NZ       Oceania
#> 8      Australia       Oceania
```

The above process required specification of all the levels but sometimes
you may not know ahead all of the levels. The `sai_lvl_sweep()` function
will attempt to clean up the levels. Below it gets most right but
classifies “Australia” wrong.

``` r
sai_lvl_sweep(messy$country)
#>             UK             US         Canada United Kingdom            USA 
#>           "UK"           "US"       "Canada"           "UK"           "US" 
#>    New Zealand             NZ      Australia 
#>           "NZ"           "NZ"           "US"
#> 
#> ── Converted by SAI: ───────────────────────────────────────────────────────────
#>         original converted
#> 1    New Zealand        NZ
#> 2 United Kingdom        UK
#> 3            USA        US
#> 4      Australia        US
```

If you know the subset of labels that are correct, you can specify this
in the argument `known` like below.

``` r
sai_lvl_sweep(messy$country, known = "Australia")
#>             UK             US         Canada United Kingdom            USA 
#>           "UK"           "US"       "Canada"           "UK"           "US" 
#>    New Zealand             NZ      Australia 
#>           "NZ"           "NZ"    "Australia"
#> 
#> ── Converted by SAI: ───────────────────────────────────────────────────────────
#>         original converted
#> 1    New Zealand        NZ
#> 2 United Kingdom        UK
#> 3            USA        US
```

### Translate

The `sai_translate()` function can be used to translate text to another
language (default English). The text can be a mix of different
languages.

``` r
text <- c("猿も木から落ちる", "你好", "bon appetit")
sai_translate(text)
#> [1] "Even monkeys fall from trees." "Hello"                        
#> [3] "Good appetite!"
```

You can also try to identify the language in the text.

``` r
sai_what_language(text)
#> [1] "Japanese" "Chinese"  "French"
```

## Images

We may have some plots (or image) and process these using a multimodal
model like `llava`. This image is available as a link
[here](https://upload.wikimedia.org/wikipedia/commons/3/35/Ggplot2_Violin_Plot.png).

<img
src="https://upload.wikimedia.org/wikipedia/commons/3/35/Ggplot2_Violin_Plot.png"
style="width:40.0%" />

We can describe the plot with `sai_describe_image()` function. The image
either has to be a url or path where the image is stored. This can be
handy to create alt text entries quickly, but note that the description
can have errors (as below).

``` r
sai_describe_image("https://upload.wikimedia.org/wikipedia/commons/3/35/Ggplot2_Violin_Plot.png",
                   model = model_ollama("llava:13b"))
```

## Dates

When combining data from different sources, inconsistencies in date
formats can occur frequently. Reformatting dates to a single format
using traditional programming requires listing all possible date formats
and can be time-consuming. The `sai_clean_date()` function uses an LLM
to standardise the dates to the international standard “YYYY-MM-DD”.

``` r
x <- c("16/02/1997", "20 November 2024", "24 Mar 2022", "2000-01-01",
       "Jason", "Dec 25, 2030", "12/05/2024")
sai_clean_date(x)
#> [1] "1997-02-16" "2024-11-20" "2022-03-24" "2000-01-01" NA          
#> [6] "2030-12-25" "2024-05-12"
```

By default, the function interprets dates in the format “XX/XX/YYYY” as
the European style “DD/MM/YYYY”. If the dates are in the US style
“MM/DD/YYYY”, you can specify the input date format using the
`input_format` option.

``` r
x <- c("12/05/2024", "Nov 15, 2024", "02/25/2024")
sai_clean_date(x, input_format = "MM/DD/YYYY")
#> [1] "2024-12-05" "2024-11-15" "2024-02-25"
```

## Addresses

When scraping data from websites or APIs, especially property-related
information, addresses can present challenges. The `sai_clean_address()`
function uses an LLM to standardise addresses into a consistent format
and returns an empty value for items that are not addresses.

``` r
x <- c("68/150 Acton Road, Acton ACT 2601",
       "655 Jackson St, Dickson ACT 2602",
       "Unit 60 523 Joey Cct, Layton NSW 6500",
       "23/100 de burgh road, Southbank VIC 7800",
       "91 Sullivan pl, Sydney nsw 6600",
       "i don't know the address")
sai_clean_address(x)
#> [1] "68/150 Acton Road, Acton ACT 2601"       
#> [2] "655 Jackson Street, Dickson ACT 2602"    
#> [3] "60/523 Joey Circuit, Layton NSW 6500"    
#> [4] "23/100 De Burgh Road, Southbank VIC 7800"
#> [5] "91 Sullivan Place, Sydney NSW 6600"      
#> [6] ""
```

## Related packages

- `air`
- `askgpt`
- `chatgpt`
- `elmer`
- `gptchatteR`
- `gptstudio`
- `gpttools`
- `TheOpenAIR`
- `tidychatmodels`
