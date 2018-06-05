% A (Xe/Lua)LaTeX document class
%
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is Olivier Pieters.
% Contact the maintainer at: me (at) olivierpieters (dot) be.
%
%    \begin{macrocode}
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
%    \end{macrocode}
%
% Load the base class.
%
%    \begin{macrocode}
\LoadClass{article}
%    \end{macrocode}
%
% More advanced length calculations.
%
%    \begin{macrocode}
\RequirePackage{calc}
\RequirePackage{graphics}
%    \end{macrocode}
%
% Needed for to draw the images.
%
%    \begin{macrocode}
\RequirePackage{tikz}
\usetikzlibrary{calc,positioning,backgrounds}
%    \end{macrocode}
%
% Needed for because of |\ifdefempty|
%
%    \begin{macrocode}
\RequirePackage{etoolbox}
%    \end{macrocode}
%
% Needed to define macros.
%
%    \begin{macrocode}
\RequirePackage{xparse}
%    \end{macrocode}
%
% Needed for key-value structures.
%
%    \begin{macrocode}
\RequirePackage{xkeyval}
%    \end{macrocode}
%
% Keeps track of data type in image node, since this can be either an
% image or text. 
%
%    \begin{macrocode}
\newif\ifrzt@imageIncluded
%    \end{macrocode}
%
% TODO: make this an option that removes all possible issues due to 
% notes and showframe
%
%    \begin{macrocode}
\newif\ifrzt@print
%    \end{macrocode}
%
% A |\newpage| is not needed for the first page, so this macro stores 
% whether we still need to typeset the first page or not.  
%
%    \begin{macrocode}
\newif\ifrzt@firstpage
\rzt@firstpagetrue
%    \end{macrocode}
%
% Counter used to check if notes have been defined ot not. These notes 
% should be removed before the final printing.  
%
%    \begin{macrocode}
\newcounter{rzt@notes}
%    \end{macrocode}
%
% Define all lengths used throughout the image class. Some lengths
% overlap with existig lengths in \LaTeX, but it is preferred to use 
% custom lengths than artificaially manipulate existing lengths to 
% avoid conflicts with other packages. 
%
% Length from the bleedline to the image. Useful to create a white 
% border. If no border is desired, this length should be set to 
% |-\rztbleed|, since very small white lines may occur otherwise. Use 
% the relevant package options to achieve a borderless album.
%    \begin{macrocode}
\newlength\rztmargin
%    \end{macrocode}
% 
% Size of the image bleed. 
%
%    \begin{macrocode}
\newlength\rztbleed
%    \end{macrocode}
%
% Width of the spine of the book. This length is only needed for the 
% cover. Does not include gutter size!
%
%    \begin{macrocode}
\newlength\rztspine
%    \end{macrocode}
%
% Size of the gutter (place where book folds when it opens). 
%
%    \begin{macrocode}
\newlength\rztgutter
%    \end{macrocode}
% 
% Width of the front cover. 
% 
%    \begin{macrocode}
\newlength\rztfront
%    \end{macrocode}
%
% Width of the back cover. 
%
%    \begin{macrocode}
\newlength\rztback
%    \end{macrocode}
%
% Separation between images on a single album page. 
%
%    \begin{macrocode}
\newlength\rztinnersep
%    \end{macrocode}
%
% Width of the entire cover. This should not be manipulated by the user!
%
%    \begin{macrocode}
\newlength\rztcoverwidth
%    \end{macrocode}
%
% Height of the entire cover. This should not be manipulated by the 
% user!
%
%    \begin{macrocode}
\newlength\rztcoverheight
%    \end{macrocode}
%
% Width of the current page. Should only be expanded when used, but
% before, since this macro is manipulated between the different 
% arguments of |\rztCover|. Should not be manipulated by the user!
%
%    \begin{macrocode}
\newlength\rztpaperwidth
%    \end{macrocode}
%
% Height of the current page. Should only be expanded when used, but
% before, since this macro is manipulated between the different 
% arguments of |\rztCover|. Should not be manipulated by the user!
%
%    \begin{macrocode}
\newlength\rztpaperheight
%    \end{macrocode}
%
% Width of an album page \emph{without bleed}.
%
%    \begin{macrocode}
\newlength\rztwidth
%    \end{macrocode}
%
% Height of an album page \emph{without bleed}.
%
%    \begin{macrocode}
\newlength\rztheight
%    \end{macrocode}
%
% Lengths used to define the image layouts.
%
%    \begin{macrocode}
\newlength\onePageHorImageWidth
\newlength\onePageHorImageHeight
\newlength\fourPageHorImageWidth
\newlength\fourPageHorImageHeight
\newlength\sixPageHorImageWidth
\newlength\sixPageHorImageHeight
\newlength\twoPageSpreadImageWidth  
\newlength\twoPageSpreadImageHeight
%    \end{macrocode}
%
% Internal lengths macros. These should \emph{not} be used or
% manipulated directly by the user!
%
% Offsets used to make images on the cover page appear at the correct
% location. This is needed since the cover is a single page for \LaTeX,
% as required the printing service. But in fact, this is a collection of
% pages (front, spine and back). 
% 
%    \begin{macrocode}
\newlength\rzt@coverxoffset
\newlength\rzt@coveryoffset
\newlength\rztKey@xshift
\newlength\rztKey@yshift
\newlength\rztKey@imgFrameXShift
\newlength\rztKey@imgFrameYShift
%    \end{macrocode}
%
% Width and height of the displayed image. Set using the |width| and 
% |height| options of images.
%
%    \begin{macrocode}
%    \end{macrocode}
%
% Size of the displayed image. This can be either height or width.
%
%    \begin{macrocode}
\newlength\rzt@imgSize
%    \end{macrocode}
%
% Size attributes for each image.
%
%    \begin{macrocode}
\newlength\rzt@imgWidth
\newlength\rzt@imgHeight
%    \end{macrocode}
%
% Size attributes for each image frame (this contains a single image).
%
%    \begin{macrocode}
\newlength\rzt@imgFrameWidth
\newlength\rzt@imgFrameHeight
%    \end{macrocode}
% 
% Apply some default values to certain lengths. 
%
%    \begin{macrocode}
\setlength\rztmargin{1cm}
\setlength\rztbleed{3mm}
\setlength\rztspine{8mm}
\setlength\rztgutter{10mm}
\setlength\rztfront{200mm}
\setlength\rztback{200mm}
\setlength\rztinnersep{0.3cm}
\setlength\rztcoverwidth{%
  2\rztbleed+\rztback+2\rztgutter+\rztspine+\rztfront}
\setlength\rztcoverheight{200mm}
\setlength\rzt@coverxoffset{0pt}
\setlength\rzt@coveryoffset{0pt}
%    \end{macrocode}
%
% \begin{macro}{\rzt@setImageDimensions}
%
% Redefines all lengths associated with image sizes. This is useful when
% album properties have changed such as the bleed size, margin or 
% paper size. 
%
%    \begin{macrocode}
\NewDocumentCommand{\rzt@setImageDimensions}{}{
  \setlength\onePageHorImageWidth{\rztpaperwidth-2\rztmargin-2\rztbleed}
  \setlength\onePageHorImageHeight{2\onePageHorImageWidth/3}

  \setlength\fourPageHorImageWidth{%
    (\onePageHorImageWidth-\rztinnersep)/2}
  \setlength\fourPageHorImageHeight{%
    (\onePageHorImageHeight-\rztinnersep)/2}

  \setlength\sixPageHorImageWidth{%
    (\onePageHorImageWidth-2\rztinnersep)/3}
  \setlength\sixPageHorImageHeight{
    (\onePageHorImageHeight-\rztinnersep)/2}

  \setlength\twoPageSpreadImageWidth{%
    2\rztpaperwidth-2\rztmargin-2\rztbleed}
  \setlength\twoPageSpreadImageHeight{%
    \rztpaperheight-2\rztmargin-2\rztbleed}
}
%    \end{macrocode}
% \end{macro}
%
% Code executed at the start of the document. 
%
%    \begin{macrocode}
\AtBeginDocument{%
%    \end{macrocode}
%
% Set the correct sizes of the |paperwidth| and |paperheight| for  
% internal macros. This cannot be set prior to this point, since we need
% to wait for the user to load the |geometry| package and we make no  
% assumptions w.r.t. the placement of the configuration macro 
% |\rztalbumsetup| and the loading of the |geometry| package. The user
% can of course still manipulate the macros him-/herself also, but
% using the |geometry| package is advised. 
%
%    \begin{macrocode}
  \setlength\rztpaperwidth{\paperwidth}
  \setlength\rztpaperheight{\paperheight}
%    \end{macrocode}
%
% Since we now know how large the pages are, we can define the image
% sizes. 
%
%    \begin{macrocode}
  \rzt@setImageDimensions
%    \end{macrocode}
%
% If requested, page numbers are removed.
%
%    \begin{macrocode}
  \ifx\ifKV@rzt@global@pagenumbers\iffalse
    \pagestyle{empty}
  \fi
%    \end{macrocode}
%
% Open file to which image data will be written. 
%
%    \begin{macrocode}
  \newwrite\rzt@imagedatafile
  \immediate\openout\rzt@imagedatafile=\jobname.rzt
  \immediate\write\rzt@imagedatafile{"images":}
%    \end{macrocode}
%
% Reset textbox macros, just in case. 
%
%    \begin{macrocode}
  \rzt@resetTextBox
}
%    \end{macrocode}
%
% At the end of the document, we need to close the file to which we 
% write the image sizes. Additionally, we also print any warnings to 
% indicate that the album is not yet finished to that the output can be
% undesirable. 
%
%    \begin{macrocode}
\AtEndDocument{%
%    \end{macrocode}
% 
% This prints a warning in case the |note| option has been used, since 
% this prints text over the image, and is only intended to serve as
% reminders when defining the album. 
%
%    \begin{macrocode}
  \ifnum\value{rzt@notes}>0
    \ClassWarningNoLine{rozet}{\the\value{rzt@notes} notes have been %
    defined! Make sure to remove these before printing or turn on the %
    print option of the class.}
  \fi
%    \begin{macrocode}
%
% Close the datafile. 
%
%    \begin{macrocode}
  \immediate\closeout\rzt@imagedatafile
}
%    \end{macrocode}
%
% TikZ style definitions for the user and inner workings.
%
%    \begin{macrocode}
\tikzset{%
%    \end{macrocode}
%
% This is the basic stsyle for each image node.
%
%    \begin{macrocode}
  rzt@basic/.style={%
    rectangle,
%    \end{macrocode}
%
% This removes the border if the node is drawn with the |\draw| macro.
%
%    \begin{macrocode}
    draw=none,
    },
%    \end{macrocode}
%
% This style is applied if no image is loaded for the node, then the 
% corresponding letter needs to be displayed. This style inherits from
% |rzt@basic|.
%
%    \begin{macrocode}
  rzt@noImage/.style={%
    rzt@basic,
    fill opacity=0.5,
    text opacity=1,
    fill=gray,
    },
%    \end{macrocode}
%
% This style is applied to images.
%
%    \begin{macrocode}
  rzt@image/.style={%
    rzt@basic,
  },
%    \end{macrocode}
%
% This style is accessable by the user and can be used to apply
% different styling to the title on the cover page. 
%
%    \begin{macrocode}
  rztcovertitle/.style={},
%    \end{macrocode}
%
% Internal definition of style applied to title on front page.
%
%    \begin{macrocode}
  rzt@covertitle/.style={
    font=\fontsize{5cm}{5.5cm}\selectfont,
    rztcovertitle,
  },
%    \end{macrocode}
%
% Same as |rztcovertitle| but for the title on the spine.
%
%    \begin{macrocode}
  rztspinecovertitle/.style={},
%    \end{macrocode}
%
% Similar to |rzt@covertitle| but for the spine.
%
%    \begin{macrocode}
  rzt@coverspinetitle/.style={
    anchor=center,
    rotate=-90,
    font=\Huge,
    rztspinecovertitle,
  },
%    \end{macrocode}
%
% Style applied to text nodes that are inserted when largers texts are 
% needed in place of images.
%
%    \begin{macrocode}
  rzt@text/.style={
    text width=\rzt@imgSize,
    align=justify,
    inner sep=0pt,
    outer sep=0pt,
  },
%    \end{macrocode}
%
% Style accessible for users that alters caption appearance. 
%
%    \begin{macrocode}
  rztcaptionstyle/.style={
    inner sep=0pt,
    outer sep=0pt,
  },
%    \end{macrocode}
%
% Internal style for captions.
%
%    \begin{macrocode}
  rzt@captionbasicstyle/.style={
    inner sep=0pt,
    outer sep=0pt,
    rztcaptionstyle,
  },
%    \end{macrocode}
% 
% Styling that is applied to the node in which the image is typeset.
% This is automatically defined per image and reset afterwards. The 
% corresponding key should be used to set the value.
%
%    \begin{macrocode}
  rzt@imgStyle/.style={},
}
%    \end{macrocode}
%
% \begin{macro}{\rztSingleAlbumPage}
%
% This macro is used to typeset a single album page. This is useful for
% the first album page, if the album starts on the right side and/or for
% the last album page if this ends on the left side. 
%
%    \begin{macrocode}
\NewDocumentCommand{\rztSingleAlbumPage}{+m}{%
  \ifx\ifrzt@firstpage\iffalse
    \newpage
  \else
    \rzt@firstpagefalse
  \fi
  \begin{tikzpicture}[remember picture,overlay]
    #1
  \end{tikzpicture}
}
%    \end{macrocode}
% \end{macro}
%
%    \begin{macrocode}
\NewDocumentCommand{\rztAlbumPage}{+m +m}{%
  \ifx\ifrzt@firstpage\iffalse
    \newpage
  \else
    \rzt@firstpagefalse
  \fi
  \begin{tikzpicture}[remember picture,overlay]
    #1
  \end{tikzpicture}
  \newpage
  \begin{tikzpicture}[remember picture,overlay]
    #2
  \end{tikzpicture}
}
%
%    \end{macrocode}
%
% Key-value options for individual images in frames.
%
%    \begin{macrocode}
\define@key{rzt@image}{note}{\def\rztKey@note{#1}}
\define@key{rzt@image}{xoffset}{\def\rztKey@xoffset{#1}}
\define@key{rzt@image}{yoffset}{\def\rztKey@yoffset{#1}}
\define@key{rzt@image}{xshift}{\setlength\rztKey@imgFrameXShift{#1}}
\define@key{rzt@image}{yshift}{\setlength\rztKey@imgFrameYShift{#1}}
\define@key{rzt@image}{width}{%
  \setlength\rzt@imgFrameWidth{#1}%
  \setlength\rzt@imgWidth{#1}%
}
\define@key{rzt@image}{height}{%
  \setlength\rzt@imgFrameHeight{#1}%
  \setlength\rzt@imgHeight{#1}%
}
\define@key{rzt@image}{ximgoffset}{\def\rztKey@ximgoffset{#1}}
\define@key{rzt@image}{yimgoffset}{\def\rztKey@yimgoffset{#1}}
\define@key{rzt@image}{ximgshift}{\def\rztKey@ximgshift{#1}}
\define@key{rzt@image}{yimgshift}{\def\rztKey@yimgshift{#1}}
\define@key{rzt@image}{zoom}{\def\rztKey@zoom{#1}}
\define@key{rzt@image}{showframe}{\def\rztKey@showframe{#1}}
\define@boolkey{rzt@image}{onlywidth}[true]{}
\define@boolkey{rzt@image}{onlyheight}[true]{}
\define@boolkey{rzt@image}{text}[true]{}
\define@key{rzt@image}{style}{\tikzset{rzt@imgStyle/.style={#1}}}
\define@key{rzt@image}{caption}{\def\rztKey@caption{#1}}
\define@key{rzt@image}{captionsetup}{%
  \tikzset{rzt@captionopt/.style={#1}}}
%    \end{macrocode}
%
% Key-value options for the album setup |\rztalbumsetup|. 
%
%    \begin{macrocode}
\define@boolkey{rzt@global}{pagenumbers}[true]{}
\define@boolkey{rzt@global}{includegutter}[true]{}
\define@boolkey{rzt@global}{cover}[true]{}
\define@boolkey{rzt@global}{rztfile}[true]{}
\define@boolkey{rzt@global}{usedraft}[true]{}
\define@key{rzt@global}{spine}{\setlength\rztspine{#1}}
\define@key{rzt@global}{bleed}{\setlength\rztbleed{#1}}
\define@key{rzt@global}{gutter}{\setlength\rztgutter{#1}}
\define@key{rzt@global}{front}{\setlength\rztfront{#1}}
\define@key{rzt@global}{back}{\setlength\rztback{#1}}
\define@key{rzt@global}{height}{\setlength\rztheight{#1}}
\define@key{rzt@global}{width}{\setlength\rztwidth{#1}}
\define@key{rzt@global}{margin}{\setlength\rztmargin{#1}}
%    \end{macrocode}
%
% Key-value options for the cover |\rztCover|. 
%
%    \begin{macrocode}
\define@key{rzt@cover}{title}{\def\rzt@covertitle{#1}}
\define@key{rzt@cover}{spinetitle}{\def\rzt@coverspinetitle{#1}}
\define@boolkey{rzt@cover}{showframe}[true]{}
%    \end{macrocode}
%
% \begin{macro}{\rztalbumsetup}
%
% This macro allows to set some global album options. A key-value syntax  
% needs to be used. 
%
%    \begin{macrocode}
\NewDocumentCommand{\rztalbumsetup}{m}{
  \setkeys{rzt@global}{%
    pagenumbers={false},%
    spine={14mm},%
    gutter={10mm},%
    bleed={19mm},%
    front={206.5mm},%
    back={206.5mm},%
    includegutter={true},%
    height={210mm},%
    width={297mm},%
    margin={10mm},%
    cover={false},%
    rztfile={true},%
    usedraft={false},%
    #1 % 
  }
  \ifKV@rzt@global@cover
    \setlength\rztcoverwidth{%
      2\rztbleed+\rztback+2\rztgutter+\rztspine+\rztfront}
    \setlength\rztcoverheight{2\rztbleed+\rztheight}
    \setlength\rztpaperwidth{%
      2\rztbleed+\rztback+2\rztgutter+\rztspine+\rztfront}
    \setlength\rztpaperheight{2\rztbleed+\rztheight}
  \else
    \setlength\rztpaperwidth{\rztwidth+2\rztbleed}
    \setlength\rztpaperheight{\rztheight+2\rztbleed}
  \fi
}
%    \end{macrocode}
% \end{macro}
%
% Turn on LaTeX3 syntax. 
%
%    \begin{macrocode}
\ExplSyntaxOn
%    \end{macrocode}
% \begin{macro}{\rzt@thelength}
%
% By default TeX length units are printed in points, but we are more 
% interested in millimetre. This macro converts between the two. 
%
% Source: \url{https://tex.stackexchange.com/questions/8260}
%
%    \begin{macrocode}
\DeclareExpandableDocumentCommand{\rzt@thelength}{ O{mm} m }
{
  \fp_to_decimal:n { round ( (#2)/(1#1), 5 ) } #1
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\@IfNoValueOrEmptyTF}
%
% This macro checks if the first argument is empty and executes the 
% second argument if true. If false, the third argument is executed.
%
%    \begin{macrocode}
\DeclareExpandableDocumentCommand{\@IfNoValueOrEmptyTF}%
  {mmm}{\IfNoValueTF{#1}{#2}{
    \tl_if_empty:nTF {#1} {#2} {#3}%
   }
}
%    \end{macrocode}
% \end{macro}
%
% Turn off LaTeX3 syntax. 
%
%    \begin{macrocode}
\ExplSyntaxOff
%    \end{macrocode}
%
% \begin{macro}{\rzt@reportImage}
%
% Writes some information of images in the album to a YAML format file. 
% This can be used to optimise images to save space and make the PDF 
% smaller. It can also be useful to identify issues.
%
% We need to manually indicate spaces to make sure the YAML data is 
% valid. The file is automatically opened at the beginning of the 
% document and closed at the end.
%
%    \begin{macrocode}
\NewDocumentCommand{\rzt@reportImage}{m}{%
  \immediate\write\rzt@imagedatafile{\space\space -}
  \immediate\write\rzt@imagedatafile{\space\space\space\space %
    "filename":\space "#1"}
  \immediate\write\rzt@imagedatafile{\space\space\space\space "width":%
    \space "\rzt@thelength{\rzt@imgWidth}"}
  \immediate\write\rzt@imagedatafile{\space\space\space\space "height":%
    \space "\rzt@thelength{\rzt@imgHeight}"}
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\rzt@boxText}
%  
% This macro stores the text passed using the |\rztTextBox| macro.
%
%    \begin{macrocode}
\def\rzt@boxText{}
%    \end{macrocode}
%
% \end{macro}
%
% \begin{macro}{\rzt@boxTextOptions}
%
% This macro stores all options passed using the |\rztTextBox| macro.
%    \begin{macrocode}
\def\rzt@boxTextOptions{}
%    \end{macrocode}
%
% \end{macro}
%
% \begin{macro}{\rztTextBox}
%
% Typesets a textbox. 
%
%    \begin{macrocode}
\NewDocumentCommand{\rztTextBox}{O{} m}{% 
%    \end{macrocode}
%
% These macros need to be typeset in the global namespace, since they 
% are used to store the arguments of |\rztTextBox|. 
%
%    \begin{macrocode}
  \gdef\rzt@boxText{#2}%
  \gdef\rzt@boxTextOptions{#1}%
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\rzt@resetTextBox}
%
% This macro is used to undefine the macros set by the |\rztTextBox|. 
% Otherwise, issues might arise where information from previous text 
% boxes is leaked to the current page.
%
%    \begin{macrocode}
\NewDocumentCommand{\rzt@resetTextBox}{}{
%    \end{macrocode}
%
% These macros need to be typeset in the global namespace, since they 
% are used to store the arguments of |\rztTextBox|. 
%
%    \begin{macrocode}
  \gdef\rzt@boxText{}%
  \gdef\rzt@boxTextOptions{}%
}
%    \end{macrocode}
% \end{macro}
%
% 
% \begin{macro}{\rzt@basicParseDefinitions}
%
% Helper macro that parses the node definitions and defines/overwrites 
% all the required macros for |\rzt@basicNodeDefinition|. In time, these
% two macros will be merged to make it easier to implement new layouts.
%
%    \begin{macrocode}
\NewDocumentCommand{\rzt@basicParseDefinitions}{mm}{%
%    \end{macrocode}
%    
% If the required argument is empty, we draw the frame using the 
% |rzt@noImage| style to indicate where the image should be. All other 
% options are deactivated and lengths are set to zero. 
%
%    \begin{macrocode}
  \@IfNoValueOrEmptyTF{#2}{%
    \def\rzt@nodestyle{rzt@noImage}%
    \def\rzt@indexLabel{\Huge #1}%
    \def\rzt@imageIncl{}%
    \setlength\rzt@imgWidth{0pt}%
    \setlength\rzt@imgHeight{0pt}%
    \rzt@imageIncludedfalse
  }{%
%    \end{macrocode}
%
% If the argument is not empty, we calculate the image size (depending 
% on which dimension needs to be used). 
%
%    \begin{macrocode}
    \ifKV@rzt@image@onlyheight% 
      \setlength{\rzt@imgSize}{\rzt@imgHeight * \real{\rztKey@zoom}}%
    \else%
      \setlength{\rzt@imgSize}{\rzt@imgWidth * \real{\rztKey@zoom}}%
    \fi%
%    \end{macrocode}
% 
% If text should be inserted in place of text, the macros are set over 
% here.
%
%    \begin{macrocode}
    \ifKV@rzt@image@text%
%    \end{macrocode}
%    
% We execute the second argument here. This is needed if a macro is 
% parsed, since this macro needs to be executed. This is savely done 
% inside a box which does not end up in the document (if no macro is 
% present). Then, we define the necessary macros to typeset the text. 
%
%    \begin{macrocode}
      \sbox{\rzt@box}{#2}
      \def\rzt@nodestyle{rzt@text}%
      \def\rzt@indexLabel{\ifdefempty{\rzt@boxText}{#2}{%
        \rzt@boxText}}%
      \def\rzt@imageIncl{}%
      \setlength\rzt@imgWidth{0pt}%
      \setlength\rzt@imgHeight{0pt}%
    \else%
%    \end{macrocode}
%
% We are including an image. Set the bool flag to true. 
%
%    \begin{macrocode}
    \rzt@imageIncludedtrue
%    \end{macrocode}
%
% This part of the code defines the options that are passed to the 
% |\includegraphics| macro.
%
%    \begin{macrocode}
      \edef\rzt@imageOptions{%
%    \end{macrocode}
%
% Check if width or height should be used.
%
%    \begin{macrocode}
        \ifKV@rzt@image@onlyheight%
          height=\rzt@imgSize,
        \else%
          width=\rzt@imgSize,
        \fi%
        %
      }%
      \def\rzt@nodestyle{rzt@image}%
      \ifdefempty{\rztKey@note}{%
        \gdef\rzt@indexLabel{}%
      }{%
        \gdef\rzt@indexLabel{\Huge\rztKey@note}%
        \stepcounter{rzt@notes}
      }
%    \end{macrocode}
%
% Save image height and width. This is useful to crop the images to make 
% the final PDF smaller without loosing quality. This is optional, but 
% activated by default.
%
%    \begin{macrocode}
      \ifKV@rzt@global@rztfile
        \settowidth\rzt@imgWidth{%
          \expandafter\includegraphics\expandafter[%
            \rzt@imageOptions]{#2\ifKV@rzt@global@usedraft -draft\fi}}%
        \settoheight\rzt@imgHeight{%
          \expandafter\includegraphics\expandafter[%
            \rzt@imageOptions]{#2\ifKV@rzt@global@usedraft -draft\fi}}%
        \rzt@reportImage{#2}
      \fi
%    \end{macrocode}
%
% Define the actual image.
%
%    \begin{macrocode}
      \def\rzt@imageIncl{%
        \node[%
          minimum height=\rzt@imgHeight,
          minimum width=\rzt@imgWidth,
        ] at ($(path picture bounding box.center)+%
          (0.5*\rzt@imgWidth*\rztKey@ximgoffset %
           - 0.5*\rzt@imgFrameWidth*\rztKey@ximgoffset %
           + \rztKey@ximgshift,%
          0.5*\rzt@imgHeight*\rztKey@yimgoffset %
           - 0.5*\rzt@imgFrameHeight*\rztKey@yimgoffset %
           + \rztKey@yimgshift)$) %
          (rzt image)
%    \end{macrocode}
%
% Two expandafters are needed to make sure that the optional arguments 
% passed to |\includegraphics| are full expanded, since this is 
% required.
%
%    \begin{macrocode}
          {\expandafter\includegraphics\expandafter[%
            \rzt@imageOptions]{#2\ifKV@rzt@global@usedraft -draft\fi}};}%
    \fi%
  }%
}
%    \end{macrocode}
% \end{macro}
% 
% \begin{macro}{\rzt@basicNodeDefinition}
%
% The macro typsets the image in the image frame. It has four required
% arguments: |{|\meta{width}|}{|\meta{height}|}{|\meta{xoffset}|}{|%
% \meta{yoffset}|}|. The optional arguments and actual image we defined 
% in |\rzt@basicParseDefinitions| are used here to create the final 
% result.
%
%    \begin{macrocode}
\NewDocumentCommand{\rzt@basicNodeDefinition}{}{%
%    \end{macrocode}
%
% Here, we typset the actual image. 
%
%    \begin{macrocode}
  \node[%
    rzt@basic,%
    minimum width=\rzt@imgFrameWidth,%
    minimum height=\rzt@imgFrameHeight,%
%    \end{macrocode}
%
% Depending on the content of the node, a different style is applied. 
% This is pre-set by the |\rzt@basicParseDefinitions| macro.
%
%    \begin{macrocode}
    \rzt@nodestyle,%
    anchor=center,%
%    \end{macrocode}
%
% Include the actual image. By using a |path picture|, we avoid overflow
% issues. The image will only be visible in the predefined frame.
%
%    \begin{macrocode}
    path picture={%
      \rzt@imageIncl%
    },%
%    \end{macrocode}
%
% If a textbox is used, additional options are inserted here. Next, the
% final coordinate is calculated, the label is set and the text is 
% included (if needed).
%
%    \begin{macrocode}
    \rzt@boxTextOptions,%
    rzt@imgStyle,%
    ] at ($(current page.center) %
          +(\rztKey@imgFrameXShift,\rztKey@imgFrameYShift)
          +(\rzt@coverxoffset,\rzt@coveryoffset)$)
    (rzt wrapper)
    {\rzt@indexLabel};
%    \end{macrocode}
%
% If a caption is set and an image is included, we add this caption. 
%
%    \begin{macrocode}
  \ifrzt@imageIncluded
    \node[rzt@captionbasicstyle,text width=\rzt@imgWidth,rzt@captionopt] {\rztKey@caption};
  \fi
%    \end{macrocode}
%
% This text box reset is needed to avoid information leakage from this
% frame to subsequent frames.
%
%    \begin{macrocode}
  \rzt@resetTextBox
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\rztCover}
%
% Defines the cover. This is made op of three parts: back, spine and 
% cover. Some optional arguments are possible. See the command reference
% for details. 
%
%    \begin{macrocode}
\NewDocumentCommand{\rztCover}{O{} mmm}{%
%    \end{macrocode}
%
% Process all optional arguments. First provide default values, then 
% process the user defined values. 
%
%    \begin{macrocode}
  \setkeys{rzt@cover}{%
    title={\@title},%
    spinetitle={\@title},%
    showframe={false},%
    #1
  }
%    \end{macrocode}
%
% Define the TikZ picture in which the entire cover will be typeset.
%
%    \begin{macrocode}
\begin{tikzpicture}[
  remember picture,
  overlay,
  every node/.style={inner sep={0pt}, outer sep={0pt}}]
%    \end{macrocode}
%
% Depending on the |includegutter| option, we set the width and hieight 
% of the current page correctly. 
%
%    \begin{macrocode}
  \ifKV@rzt@global@includegutter
    \setlength\rztpaperwidth{\rztfront+\rztgutter+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \else
    \setlength\rztpaperwidth{\rztfront+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \fi
%    \end{macrocode}
%
% Calling this macro will redefine lengths such as 
% |\onePageHorImageWidth| and |\onePageHorImageHeight|, because the page
% dimensions have changed.
%
%    \begin{macrocode}
  \rzt@setImageDimensions
%    \end{macrocode}
%
% This offset is needed to ensure the images appear where they need to.
% Otherwise, they would apprear with an offset. This si fixed over here.
%
%    \begin{macrocode}
  \ifKV@rzt@global@includegutter
    \setlength\rzt@coverxoffset{%
      -0.5\rztspine-0.5\rztgutter-0.5\rztfront-0.5\rztbleed}
  \else
    \setlength\rzt@coverxoffset{%
      -0.5\rztspine-\rztgutter-0.5\rztfront-0.5\rztbleed}
  \fi
%    \end{macrocode}
%
% Calling this macro will redefine lengths such as 
% |\onePageHorImageWidth| and |onePageHorImageHeight|, because the page 
% dimensions have changed.
%
%    \begin{macrocode}
  \rzt@setImageDimensions
%    \end{macrocode}
%
% Include the first image argument.
%
%    \begin{macrocode}
  #2
%    \end{macrocode}
%
% Similar as before, but now for the spine.
%
%    \begin{macrocode}
  \ifKV@rzt@global@includegutter
    \setlength\rztpaperwidth{\rztspine}
    \setlength\rztpaperheight{\rztcoverheight}
  \else
    \setlength\rztpaperwidth{2\rztgutter+\rztspine}
    \setlength\rztpaperheight{\rztcoverheight}
  \fi
  \setlength\rzt@coverxoffset{0pt}
  #3
%    \end{macrocode}
%
% Similar as before, but now for the front side.
%
%    \begin{macrocode}
  \ifKV@rzt@global@includegutter
    \setlength\rztpaperwidth{\rztfront+\rztgutter+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \else
    \setlength\rztpaperwidth{\rztfront+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \fi
  \rzt@setImageDimensions
  
  \ifKV@rzt@global@includegutter
    \setlength\rzt@coverxoffset{%
      0.5\rztspine+0.5\rztgutter+0.5\rztfront+0.5\rztbleed}
  \else
    \setlength\rzt@coverxoffset{%
      0.5\rztspine+\rztgutter+0.5\rztfront+0.5\rztbleed}
  \fi
  #4
%    \end{macrocode}
%
% If the |showframe| is activated, we need to draw the different 
% margins and safe zones. These are drawn over here in different 
% colours.
%
%    \begin{macrocode}
  \ifKV@rzt@cover@showframe
%    \end{macrocode}
%
% Draw the book spine.
%
%    \begin{macrocode}
    \draw[green] (current page.north) 
      -- ++(\rztspine/2,0) 
      -- ++(0,-\rztcoverheight) 
      -- ++(-\rztspine,0) 
      -- ++(0,\rztcoverheight) 
      -- cycle;
%    \end{macrocode}
%
% Draw the gutters. 
%
%    \begin{macrocode}
    \draw[red] (current page.north)++(\rztspine/2,0) 
      -- ++(\rztgutter,0) 
      -- ++(0,-\rztcoverheight) 
      -- ++(-\rztgutter,0) 
      -- ++(0,\rztcoverheight) 
      -- cycle;
    \draw[blue] (current page.north)++(-\rztspine/2,0) 
      -- ++(-\rztgutter,0) 
      -- ++(0,-\rztcoverheight) 
      -- ++(\rztgutter,0) 
      -- ++(0,\rztcoverheight) 
      -- cycle;
%    \end{macrocode}
%
% Draw the bleed.
%
%    \begin{macrocode}
    \draw[yellow] (current page.north west) ++(\rztbleed,-\rztbleed) 
      -- ++(0,-\rztcoverheight+2\rztbleed) 
      -- ++(\rztcoverwidth-2\rztbleed,0) 
      -- ++(0,\rztcoverheight-2\rztbleed)  
      -- cycle;
  \fi
%    \end{macrocode}
%
% Add the title text to the spine
%
%    \begin{macrocode}
  \node[rzt@coverspinetitle,white] 
    at (current page.center) 
    {\fontsize{0.75\rztspine}{0.85\rztspine}\selectfont %
     \rzt@coverspinetitle %
    };
%    \end{macrocode}
%
% Add the title text to the front page.
%
%    \begin{macrocode}
  \node[rzt@covertitle,white,align=right,anchor=south east] 
  at ($(current page.south east)+(-2\rztbleed,2\rztbleed)$) 
  {\rzt@covertitle };
\end{tikzpicture}
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\rztBackground}
% 
% The background colour macro. This macro can be used to add a colour or 
% similar to the background. It draws this over the entire page. 
%
%    \begin{macrocode}
\NewDocumentCommand{\rztBackground}{m}{
  \node[
    minimum width=\rztpaperwidth, %
    minimum height=\rztpaperheight, %
    #1 %
    ] at (current page.center) {};
}
%    \end{macrocode}
% \end{macro}

