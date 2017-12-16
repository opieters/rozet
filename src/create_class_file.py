import yaml,math

if __name__ == "__main__":
    # load .cls file
    source_file = open("rozet_base.cls").readlines()

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
            command += "\\NewDocumentCommand{%s}{%s}{%%\n" % (name, arguments)
            command += "  \\begingroup%\n"
            for j in range(n_args):
                command += "  \\setkeys{rst@image}{%%\n"
                command += "    xoffset={0},\n"
                command += "    yoffset={0},\n"
                command += "    onlywidth={true},\n"
                command += "    onlyheight={false},\n"
                command += "    zoom={1},\n"
                command += "    width={%s},\n" % images[j]["width"]
                command += "    height={%s},\n" % images[j]["height"]
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


        source_file += command

    source_file += "\\endinput\n"

    with open("rozet.cls", "w") as f:
        f.writelines(source_file)


