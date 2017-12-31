import yaml,math

if __name__ == "__main__":
    # load .cls file
    source_file = open("rozet_base.dtx").readlines()

    data = yaml.load(open("frame_definitions.yml"))
    data = [i for i in data if i["name"] != ""]

    for frame_idx, frame in enumerate(data):
      source_file += "%% \subsection{\\texttt{%s}}\label{frame-definitions}\n%%\n" % frame["name"].replace("\\", "\\textbackslash ")

      source_file += ("%% \DescribeMacro{%s}" % frame["name"]) + ("\\allowbreak |[|\\meta{options}|]|\\allowbreak |{|\meta{image}|}|"*len(frame["images"])) + "\n%\n"
      
      source_file += "% \\begin{tikzpicture}[every node/.style={inner sep=0pt,outer sep=0pt}]\n%"

      for j, i in enumerate(frame["images"]):
        source_file += "% \\node[\n"
        source_file += "% rectangle,\n"
        source_file += "%% minimum width=%s,\n" % i["width"]
        source_file += "%% minimum height=%s,\n" % i["height"]
        source_file += "% fill opacity=0.5,text opacity=1,fill=gray,\n"
        source_file += "% anchor=center,\n"
        source_file += "% ] at ($(0,0)\n"
        source_file += "%% +(%s,%s)$)\n" % (i["x_offset"], i["y_offset"])
        source_file += "% (rzt wrapper)\n"
        source_file += "%% {%d};\n" % (j+1)
        if "caption" in i:
          source_file += "%% \\node[%s=0.025cm of rzt wrapper,draw,rectangle,text width=%s,inner sep=0,outer sep=0,fill=green,green] {};\n" % (i["caption"]["position"], i["width"])
        else:
          source_file += "%% \\node[above=0.025cm of rzt wrapper,draw,rectangle,text width=%s,inner sep=0,outer sep=0,fill=green,green] {};\n" % i["width"]
        source_file += "% \\node[draw,rectangle,minimum width=\\rztpaperwidth+2\\rztbleed,minimum height=\\rztpaperheight+2\\rztbleed,anchor=center] at (0,0) {};\n"

      source_file += "% \\end{tikzpicture}\n%\n"
    
      if frame_idx % 2 == 1:
        source_file += "% \clearpage\n"

    source_file += "% \StopEventually{\PrintChanges\PrintIndex}\n"
    source_file += "%\n"
    source_file += "% \section{Implementation}\n"
    source_file += "%\n"

    source_file += "% \\iffalse\n"
    source_file += "%<*class>\n"
    source_file += "% \\fi\n"

    # Add the contents of the cls file

    source_file += open("rozet_base.cls").readlines()

    data = yaml.load(open("frame_definitions.yml"))
    data = [i for i in data if i["name"] != ""]

    # command name and arguments
    for frame in data:
        command = ""

        name = frame["name"]
        n_images = len(frame["images"])
        n_cmds = math.ceil(n_images / 4)
        for i in range(n_cmds):
            n_args = min([4,n_images - i*4])
            images = frame["images"][i*4:(i+1)*4]

            # argument structure
            arguments = " ".join(["O{}m"]*n_args)

            # command name
            if i != 0:
                name = name.replace("\\rzt", "\\rzt@") + "Cont"
            if i > 1:
                name = name + "x"*(i-1)

            # start parsing command definition
            command += "%    \\begin{macrocode}\n"
            command += "\\NewDocumentCommand{%s}{%s}{%%\n" % (name, arguments)
            command += "  \\begingroup%\n"
            for j in range(n_args):
                command += "  \\setkeys{rzt@image}{%%\n"
                command += "    xoffset={0},\n"
                command += "    yoffset={0},\n"
                command += "    xshift={%s},\n" % (images[j]["xshift"] if "xshift" in images[j] else "0")
                command += "    yshift={%s},\n" % (images[j]["yshift"] if "yshift" in images[j] else "0")
                command += "    onlywidth={true},\n"
                command += "    onlyheight={false},\n"
                command += "    zoom={1},\n"
                command += "    note={},\n"
                command += "    width={%s},\n" % (images[j]["image_width"] if "image_width" in images[j] else images[j]["width"])
                command += "    height={%s},\n" % (images[j]["image_height"] if "image_height" in images[j] else images[j]["height"])
                command += "    text={false},%\n"
                command += "    caption={},%\n"
                command += "    showframe=false,%\n"
                command += "    captionsetup={%s=0.1cm of rzt wrapper,align=%s},%%\n" % (images[j]["caption"]["position"], images[j]["caption"]["align"])
                command += "    #%d}%%\n" % (2*j+1)

                command += "  \\rzt@basicParseDefinitions{%s}{#%d}%%\n" % (chr(ord("A")+j+4*i), 2*j+2)

                command += "  \\rzt@basicNodeDefinition%\n"
                command += "    {%s}%%\n" % frame["images"][j]["width"]
                command += "    {%s}%%\n" % frame["images"][j]["height"]
                command += "    {%s}%%\n" % frame["images"][j]["x_offset"]
                command += "    {%s}%%\n" % frame["images"][j]["y_offset"]

            if i == (n_cmds-1):
                pass
            else:
                next_name = frame["name"]
                if i != 0:
                    next_name = next_name.replace("\\rzt", "\\rzt@") + "Cont"
                if i > 1:
                    next_name = next_name + "x" * (i - 1)
                command += "  %s%%\n" % next_name

            command += "  \\endgroup%\n"
            command += "}\n\n"
            command += "%    \end{macrocode}\n"


        source_file += command


    source_file += "% \\iffalse\n"
    source_file += "%</class>\n"
    source_file += "% \\fi\n"
    source_file += "%\n"
    source_file += "% \\Finale\n"

    source_file += "\\endinput\n"

    with open("rozet.dtx", "w") as f:
        f.writelines(source_file)


