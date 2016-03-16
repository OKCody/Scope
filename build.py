pageContent = open('content/index.html', 'r')
pageContent = pageContent.read()
page = open('index.html', 'a')


    
def mkFooter():
    page.write('<footer>\n')
    page.write('<div class="row">\n')
    page.write('<div class="twelve columns footer">\n')
    page.write('<a href="#">\n')
    page.write('<div class="license" id="cc"></div>\n')
    page.write('<div class="license" id="by"></div>\n')
    page.write('<div class="license" id="nc"></div>\n')
    page.write('<div class="license" id="nd"></div>\n')
    page.write('<div class="license" id="sa"></div>\n')
    page.write('<div class="license" id="nc-eu"></div>\n')
    page.write('<div class="license" id="nc-jp"></div>\n')
    page.write('<div class="license" id="pd"></div>\n')
    page.write('<div class="license" id="remix"></div>\n')
    page.write('<div class="license" id="sampling-plus"></div>\n')
    page.write('<div class="license" id="sampling"></div>\n')
    page.write('<div class="license" id="share"></div>\n')
    page.write('<div class="license" id="zero"></div>\n')
    page.write('</a>\n')
    page.write('<a href="#" class="rss"></a>\n')
    page.write('</div>\n')
    page.write('</div>\n')
    page.write('</footer>\n')
    
def mkMain(pageContent):
    page.write('<div class="row main">\n')
    page.write('<div class="twelve columns">\n')
    page.write('<!--Begin Content-->\n')
    page.write('\n')
    page.write(pageContent)
    page.write('\n')
    page.write('<!--End Content-->\n')
    page.write('</div>\n')
    page.write('<!--End twelve columns-->\n')
    page.write('</div>\n')
    
def mkHeader():
    page.write('<header>\n')
    page.write('<div class="row">\n')
    page.write('<a href="#"><div class="twelve columns logo" href="#"></div></a>\n')
    page.write('</div>\n')
    page.write('<div class="row menu">\n')
    page.write('<a href="#"><div class="three columns menu" id="home">Home</div></a>\n')
    page.write('<a href="#"><div class="three columns menu" id="archive">Archive</div></a>\n')
    page.write('<a href="#"><div class="three columns menu" id="about">About</div></a>\n')
    page.write('<div class="three columns menu"><form id="search-form"><input id="search" type="text" name="search" placeholder="Search"><input type="submit" id="submit" value=""></input></form></div>\n')
    page.write('</div>\n')
    page.write('</header>\n')

def mkHead():
    page.write('<head>\n')
    page.write('<link rel="stylesheet" type="text/css" href="normalize.css">\n')
    page.write('<link rel="stylesheet" type="text/css" href="skeleton.css">\n')
    page.write('<link rel="stylesheet" type="text/css" href="style.css">\n')
    page.write('</head>\n')
    
def mkBody(pageContent):
    page.write('<body>\n')
    page.write('<div class="container">\n')
    mkHeader()
    mkMain(pageContent)
    mkFooter()
    page.write('<!--End container-->\n')
    page.write('</div>\n')
    page.write('</body>\n')

def mkHTML(pageContent):
    page.write('<html>\n')
    mkHead()
    mkBody(pageContent)
    page.write('</html>\n')

mkHTML(pageContent)

page.close()