import yaml,math

if __name__ == "__main__":
    # load .cls file
    source_file = ""

    data = yaml.load(open("frame_definitions.yml"))
    data = [i for i in data if i["name"] != ""]

    source_file += "\\documentclass{article}\n"
    source_file += "\\usepackage{tikz}\n"
    source_file += "\\usepackage{calc}\n"
    source_file += "\\usepackage[landscape]{geometry}"
    source_file += "\\usetikzlibrary{calc,positioning}\n"
    source_file += "\\newlength\\rztmargin \\newlength\\rztbleed \\setlength\\rztmargin{1cm} \\setlength\\rztbleed{3mm} \\newlength\\rztinnersep \\setlength\\rztinnersep{0.3cm}"

    source_file += "\\newlength\\rztpaperwidth \\newlength\\rztpaperheight\\setlength\\rztpaperwidth{0.2\\paperwidth}\\setlength\\rztpaperheight{0.2\\paperheight}\n"

    source_file += "\\newlength\\onePageHorImageWidth \\newlength\onePageHorImageHeight \\newlength\\fourPageHorImageWidth \\newlength\\fourPageHorImageHeight \\newlength\\sixPageHorImageWidth \\newlength\\sixPageHorImageHeight \\newlength\\twoPageSpreadImageWidth \\newlength\\twoPageSpreadImageHeight\n"

    source_file += "\\setlength\\onePageHorImageWidth{\\rztpaperwidth-2\\rztmargin-2\\rztbleed} \\setlength\\onePageHorImageHeight{2\\onePageHorImageWidth/3} \\setlength\\fourPageHorImageWidth{(\\onePageHorImageWidth-\\rztinnersep)/2} \\setlength\\fourPageHorImageHeight{(\\onePageHorImageHeight-\\rztinnersep)/2} \\setlength\\sixPageHorImageWidth{(\\onePageHorImageWidth-2\\rztinnersep)/3} \\setlength\\sixPageHorImageHeight{(\\onePageHorImageHeight-\\rztinnersep)/2} \\setlength\\twoPageSpreadImageWidth{\\rztpaperwidth-\\rztmargin} \\setlength\\twoPageSpreadImageHeight{\\rztpaperheight-2\\rztmargin}\n"

    source_file += "\\begin{document}\n"


    for frame in data:
      source_file += "\\clearpage"
      source_file += "\\verb|%s|\n" % frame["name"]
      
      source_file += "\\begin{tikzpicture}\n"

      for j, i in enumerate(frame["images"]):
        source_file += "\\node[\n"
        source_file += "rectangle,\n"
        source_file += "minimum width=%s,\n" % i["width"]
        source_file += "minimum height=%s,\n" % i["height"]
        source_file += "fill opacity=0.5,text opacity=1,fill=gray,\n"
        source_file += "anchor=center,\n"
        source_file += "] at ($(0,0)\n"
        source_file += "+(%s,%s)$)\n" % (i["x_offset"], i["y_offset"])
        source_file += "(rzt wrapper)\n"
        source_file += "{%d};\n" % (j+1)
        source_file += "\\node[above=0cm of rzt wrapper,draw,rectangle,text width=%s] {caption};\n" % i["width"]

      source_file += "\\end{tikzpicture}\n"

    source_file += "\\end{document}\n"
    source_file += "\\endinput\n"

    with open("rozet_dtx.tex", "w") as f:
        f.writelines(source_file)


