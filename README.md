# Scope
Git &amp; Bash - based static website generator
## Description
Scope is a light-weight static-website building tool.  Its template is simple and easily customizable.  First order adjustments can be made to site-style/style.css. Other, more structural changes should be made to site-template/head.html & site-template/tail.html. The contents of head.html and tail.html are prepended and appended respectively to the content of your pages. That is, everything that lives between <body> and </body>. Content can be written in either HTML or Markdown. Upon execution of build.sh, the contents of your site are processed by Markdonw.pl, sandwiched between the HTML in site-template/head.html and site-template/tail.html and then stored in the content/ directory created by the build.sh script and are ready to be served. 

build.sh is intended to be called as a CGI script.  This way is is not necessary to log into the server to rebuild the site or it can be configured to run nightly. That is, the intention is for users to write their content locally using Markdown, push their content to Github, and then click a bookmark in a browser that points to the build.sh CGI script that would immediately re-build the site. 

Inspiration for this project comes from my frustration with uisng Wordpress to maintain a tiny, very simple website and my unwillingness to dive into Jekyll.  I've been using Wordpress for a couple years and have grown tired of templates that are insanely complicated and authoring tools that are distracting and cantankerous. Wordpress and Jekyll are both execellent projects, but are more complicated than I require. I wanted a solution that was as simple as possible, that supports HTML or Markdown content written in an editor of my choice, and employes version control. -a tool that does not depend on PHP and generates static pages that will rot gracefully on the web with little to no maintainence.

## Setup
This tool depends on the use of sed.  Sed is included in Linux distributions but is missing from OS X. To install use the following:

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

`export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"`

`brew install coreutils`

`export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"`

included in coreutils is gnused, in the last line command we remove the gnu prefix in order to use is as we would on a Linux system.

## Dependencies
Depends on wkhtmltopdf for generating PDFs. 
