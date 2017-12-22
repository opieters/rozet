import yaml,math

if __name__ == "__main__":
    # load .cls file
    source_file = open("rozet_base.dtx").readlines()

    data = yaml.load(open("frame_definitions.yml"))
    data = [i for i in data if i["name"] != ""]

    for frame_idx, frame in enumerate(data):
      source_file += "%% \subsection{\\texttt{%s}}\n%%\n" % frame["name"].replace("\\", "\\textbackslash ")

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
        source_file += "%% \\node[above=0.025cm of rzt wrapper,draw,rectangle,text width=%s,inner sep=0,outer sep=0,fill=green,green] {};\n" % i["width"]
        source_file += "% \\node[draw,rectangle,minimum width=\\rztpaperwidth+2\\rztbleed,minimum height=\\rztpaperheight+2\\rztbleed,anchor=center] at (0,0) {};\n"

      source_file += "% \\end{tikzpicture}\n%\n"
    
      if frame_idx % 2 == 1:
        source_file += "% \clearpage\n"

    source_file += "% \StopEventually{}"
    source_file += "%"
    source_file += "% \section{Implementation}"
    source_file += "%"

    source_file += "\\end{document}\n"
    source_file += "\\endinput\n"

    with open("rozet.dtx", "w") as f:
        f.writelines(source_file)


