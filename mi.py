import string,cgi,time,os,urllib
from os import curdir, sep
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

class SimpleHandler(BaseHTTPRequestHandler):
    
    def Menu(self):
        try:
            import subprocess as sub
            p = sub.Popen(["sh","/Applications/iNalyzer5.app/Menu.sh"],stdout=sub.PIPE,stderr=sub.PIPE)
            output, errors = p.communicate()
            self.send_response(200)
            self.send_header('Content-type',        'text/html')
            self.end_headers()
            self.wfile.write(output)
            return
        except:
            return
    
    
    def do_GET(self):
        try:
            print self.path
            if ( self.path == "/" ):
               	import subprocess as sub
            	p = sub.Popen(["sh","/Applications/iNalyzer5.app/Menu.sh"],stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
            	self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	return
            
            if ( self.path.startswith("/iNalyzer") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("App=")[1].split("&EOFname=")[0]
            	print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line='/Applications/iNalyzer5.app/packApp.sh'+' '+'\''+app+'\''
            	import shlex
            	args = shlex.split(command_line)
            	print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
            	if (errors):
            		print errors
            		return
            	z="/var"+output.split("/var")[1].split(".ipa")[0]+".ipa"
            	if (z):
                    ame=z.split("/")
                    print ame
                    name=ame[ame.__len__()-1]
                    print name
                    self.send_response(200)
                    self.send_header('Content-type',        'application/zip')
                    self.send_header('Content-Disposition', 'attachment; filename="'+name.split(".ipa")[0]+'.zip"')
                    self.end_headers()
                    #res=os.system("iTell "+appname+" `cat "+htname_out+"| tr '\n' '@' ` > "+htname+"_tell")
                    nfile= open(z.replace('\\ '," "),'rb')
                    self.wfile.write(nfile.read())
                    nfile.close()
                #res=os.system("rm "+fullname+" "+fullout)
                #return
            	#self.wfile.write("file is:"+z)
            	return
            
            if ( self.path == "/listApps" ):
            	import subprocess as sub
            	p = sub.Popen(["sh","/Applications/iNalyzer5.app/listApp.sh"],stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
            	self.wfile.write(output)
            	self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	return
            
            if ( self.path.find("Invoke=") > -1):
                data=self.path.split("Invoke=")[1].split("&EndInvoke")[0]
                appname=self.path.split("/")[1]
                #print ("data:"+data)
                #print("appname:"+appname)
                htname='tmp'+str(time.time()).split(".")[0]
                #print(htname)
                fullname="/tmp/"+htname
                fullout="/tmp/"+htname+"_out"
                #print(fullname)
                if ( urllib.unquote(data) == "??init" ):
                	import subprocess as sub
                	p = sub.Popen(["cp","/Applications/iNalyzer5.app/helper_init.cy",fullname],stdout=sub.PIPE,stderr=sub.PIPE)
                	output, errors = p.communicate()
                else:
                	d = open(fullname,'w')
                	#d.write(appname+" ")
                	print(urllib.unquote(data).replace(";;",";\n"))
                	d.write(urllib.unquote(data).replace(";;",";\n"))
                	d.close()
                self.send_response(200)
                self.send_header('Content-type',        'text/html')
                self.send_header('Access-Control-Allow-Origin','*')
                self.end_headers()
                #self.wfile.write("output of "+fullname+" file:<br>")
                #res=os.system("cat "+htname+" >"+htname+"_out")
                #res=os.system("echo "+appname+" >"+htname+"_out")
                #print ("/usr/bin/cycript -p "+appname+" "+fullname+" = "+fullout)
                res=os.system("/usr/bin/cycript -p `ps -ef | grep -v grep | grep '"+urllib.unquote(appname)+".app' | awk '{print $2;}'` "+fullname+" > "+fullout)
                if (res == 0):
                    #res=os.system("iTell "+appname+" `cat "+htname_out+"| tr '\n' '@' ` > "+htname+"_tell")
                    nfile= open(fullout,'r')
                    self.wfile.write(cgi.escape(nfile.read()).replace("\n","<br>"))
                    nfile.close()
                    res=os.system("rm "+fullname+" "+fullout)
                    return
            Menu(self)
            self.send_response(200)
            self.send_header('Content-type',        'text/html')
            self.end_headers()
            self.wfile.write("no input")
        except:
            return
        return
    
    def do_POST(self):
        form = cgi.FieldStorage(  fp=self.rfile, headers=self.headers, environ={'REQUEST_METHOD':'POST', 'CONTENT_TYPE':self.headers['Content-Type'], })
        data=''
        for field in form.keys():
            field_item = form[field]
            data=data+'&'+field+'='+form[field].value
        htname='tmp'+str(time.time()).split(".")[0]
        d = open(curdir+sep+htname,'w')
        d.write(urllib.unquote(data))
        d.close()
        self.send_response(200)
        self.send_header('Content-type',        'text/html')
        self.end_headers()
        self.wfile.write("hey, written to"+htname)
        res=os.system("cat "+htname+" >"+htname+"_out")
        if (res == 0):
            nfile= open(curdir+sep+htname+"_out",'r')
            self.wfile.write(nfile.read())
            nfile.close()
        return

def main():
    try:
        server = HTTPServer(('', 5544), SimpleHandler)
        print 'starting server...'
        server.serve_forever()
    except KeyboardInterrupt:
        print '^C -> stopping server'
        server.socket.close()

if __name__ == '__main__':
    main()
