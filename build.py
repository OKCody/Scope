pageContent = open('content/index.html', 'r')
pageContent = pageContent.read()
page = open('index.html', 'a')


    
def mkFooter():
    page.write('<footer>\n')
    page.write('</footer>\n')
    
def mkMain(pageContent):
    page.write(pageContent)
    page.write('\n')
    
def mkHeader():
    page.write('<header>\n')
    page.write('</header>\n')

def mkHead():
    page.write('<head>\n')
    page.write('</head>\n')
    
def mkBody(pageContent):
    page.write('<body>\n')
    mkHeader()
    mkMain(pageContent)
    mkFooter()
    page.write('</body>\n')

def mkHTML(pageContent):
    page.write('<html>\n')
    mkHead()
    mkBody(pageContent)
    page.write('</html>\n')

mkHTML(pageContent)

page.close()