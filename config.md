<!--
Add here global page variables to use throughout your website.
-->
+++
author = "Guillermo Angeris"
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Longest Path Search"
website_descr = "Because finding the shortest path is boring (and not NP-hard)."
website_url = "https://angeris.github.io/blog/"
rss_full_content = true
+++
<!--website_url   = "https://guille.site/"-->

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\reals}{\mathbf{R}}
\newcommand{\scal}[1]{\langle #1 \rangle}
\newcommand{\diag}{\mathbf{diag}}
