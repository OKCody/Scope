indexContent = open('content/index.html', 'r')
indexContent = indexContent.read()
index = open('index.html', 'a')
	
#def mkStyle():

#def mkHeader():

def mkBody(content):
   index.write(content)

#def mkFooter():
#-----main-----
index.write('<html>')
index.write('<style>')
index.write('</style>')
index.write('<head>')
index.write('</head>')
index.write('<body>')
mkBody(indexContent)
index.write('</body>')
index.write('</html>')
#-----/main-----

index.close()