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
\RequirePackage{kvoptions}
\ProcessKeyvalOptions*
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage{calc}
%\RequirePackage{geometry}
\RequirePackage{graphics}
\RequirePackage{tikz}

\usetikzlibrary{calc,positioning,backgrounds}

\RequirePackage{xparse}
\RequirePackage{xkeyval}

\newif\ifrzt@imageIncluded

\newlength\rztmargin
\newlength\rztbleed
\newlength\rztspine
\newlength\rztgutter
\newlength\rztfront
\newlength\rztback
\newlength\rztinnersep
\newlength\rztcoverwidth
\newlength\rztcoverheight
\newlength\rztpaperwidth
\newlength\rztpaperheight
\newlength\rztwidth
\newlength\rztheight
\newlength\onePageHorImageWidth
\newlength\onePageHorImageHeight
\newlength\fourPageHorImageWidth
\newlength\fourPageHorImageHeight
\newlength\sixPageHorImageWidth
\newlength\sixPageHorImageHeight
\newlength\twoPageSpreadImageWidth  
\newlength\twoPageSpreadImageHeight
\newlength\rzt@coverxoffset
\newlength\rzt@coveryoffset
\newlength\rztKey@width
\newlength\rztKey@height
\newlength\rzt@imgSize
% % define size attributes for each image
\newlength\rzt@imgWidth
\newlength\rzt@imgHeight
\newlength\rzt@imgFrameWidth
\newlength\rzt@imgFrameHeight


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

\AtBeginDocument{%
  \setlength\rztpaperwidth{\paperwidth}
  \setlength\rztpaperheight{\paperheight}

  \rzt@setImageDimensions

  \ifx\ifKV@rzt@global@pagenumbers\iffalse
    \pagestyle{empty}
  \fi

  \newwrite\rzt@imagedatafile
  \immediate\openout\rzt@imagedatafile=\jobname.rzt
  \immediate\write\rzt@imagedatafile{"images":}

  \rzt@resetTextBox
}
%    \end{macrocode}

%    \begin{macrocode}
\AtEndDocument{%
  \immediate\closeout\rzt@imagedatafile
}
%    \end{macrocode}

%    \begin{macrocode}
\tikzset{%
  rzt@basic/.style={%
    rectangle,
    },
  rzt@noImage/.style={%
    rzt@basic,
    fill opacity=0.5,
    text opacity=1,
    fill=gray,
    },
  rzt@image/.style={%
    rzt@basic,
  },
  rosetta@PhotoStyle/.style={%
  },
  rztcovertitle/.style={},
  rzt@covertitle/.style={
    font=\fontsize{5cm}{5.5cm}\selectfont,
    rztcovertitle,
  },
  rztspinecovertitle/.style={},
  rzt@coverspinetitle/.style={
    anchor=center,
    rotate=-90,
    font=\Huge,
    rztspinecovertitle,
  },
  rzt@text/.style={
    text width=\rzt@imgSize,
    align=justify,
    inner sep=0pt,
    outer sep=0pt,
  },
  rzt@captionbasicstyle/.style={
    inner sep=0pt,
    outer sep=0pt,
    align=center,
    text width=\rzt@imgSize,
    above=0cm of rzt image.north,
    anchor=south,
  },
}
%    \end{macrocode}

%    \begin{macrocode}
\NewDocumentCommand{\rztFirstAlbumPage}{+m}{%
  \begin{tikzpicture}[remember picture,overlay]
    #1
  \end{tikzpicture}
}
%    \end{macrocode}

%    \begin{macrocode}
\NewDocumentCommand{\rztLastAlbumPage}{+m}{%
  \newpage
  \rztFirstAlbumPage{#1}%
}
%    \end{macrocode}
%
%    \begin{macrocode}
\NewDocumentCommand{\rztAlbumPage}{+m +m}{%
  \newpage
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
\define@key{rzt@image}{xshift}{\def\rztKey@xshift{#1}}
\define@key{rzt@image}{yshift}{\def\rztKey@yshift{#1}}
\define@key{rzt@image}{width}{\setlength\rztKey@width{#1}}
\define@key{rzt@image}{height}{\setlength\rztKey@height{#1}}
\define@key{rzt@image}{zoom}{\def\rztKey@zoom{#1}}
\define@key{rzt@image}{showframe}{\def\rztKey@showframe{#1}}
\define@boolkey{rzt@image}{onlywidth}[true]{}
\define@boolkey{rzt@image}{onlyheight}[true]{}
\define@boolkey{rzt@image}{text}[true]{}
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
% \begin{macro}{\rzt@IfNoText}
%
% By default TeX length units are printed in points, but we are more 
% interested in millimetre. This macro converst between the two. 
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
% \begin{macro}{\rzt@IfNoText}
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
% \begin{macro}{\rzt@IfNoText}
% 
% This macro checks if the first argument results in an empty text or 
% not. If true, the second argument is exectuted, otherwise the third 
% argument. 
%
% Based on: \url{https://tex.stackexchange.com/questions/44919}.
%
%    \begin{macrocode}
\NewDocumentCommand{\rzt@IfNoText}{mmm}{%
%    \end{macrocode}
%
% |\begingroup|/|\endgroup| keeps the assignment to \box0 local.
%
%    \begin{macrocode}
  \begingroup
  \sbox0{#1}%
  \ifdim\wd0=0pt %
      {#2}% if #1 is empty
  \else%
    \ifdim0pt=\dimexpr\ht0+\dp0\relax
      {#2}
    \else
      {#3}% if #1 is not empty
    \fi
  \fi%
  \endgroup
}
%    \end{macrocode}
% \end{macro}
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
      \setlength{\rzt@imgSize}{\rztKey@height * \real{\rztKey@zoom}}%
    \else%
      \setlength{\rzt@imgSize}{\rztKey@width * \real{\rztKey@zoom}}%
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
      \def\rzt@indexLabel{\rzt@IfNoText{\rzt@boxText}{#2}{%
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
      \def\rzt@indexLabel{\Huge\rztKey@note}%
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
        \node at ($(path picture bounding box.center)+%
          (0.5*\rzt@imgWidth*\rztKey@xoffset %
           - 0.5*\rzt@imgFrameWidth*\rztKey@xoffset %
           + \rztKey@xshift,%
          0.5*\rzt@imgHeight*\rztKey@yoffset %
           - 0.5*\rzt@imgFrameHeight*\rztKey@yoffset %
           + \rztKey@yshift)$) %
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
\NewDocumentCommand{\rzt@basicNodeDefinition}{mm mm}{%
%    \end{macrocode}
%
% Define the target image width and height. This is used internally, to
% typset the images.
%
%    \begin{macrocode}
  \setlength\rzt@imgFrameWidth{#1}%
  \setlength\rzt@imgFrameHeight{#2}%
%    \end{macrocode}
%
% Here, we typset the actual image. 
%
%    \begin{macrocode}
  \node[%
    rzt@basic,%
    minimum width=#1,%
    minimum height=#2,%
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
    ] at ($(current page.center) %
          +(#3,#4)
          +(\rzt@coverxoffset,\rzt@coveryoffset)$)
    (rzt wrapper)
    {\rzt@indexLabel};
%    \end{macrocode}
%
% If a caption is set and an image is included, we add this caption. 
%
%    \begin{macrocode}
  \ifrzt@imageIncluded
    \node[rzt@captionbasicstyle,rzt@captionopt] {\rztKey@caption};
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
    \draw[yellow] (current page.north west) ++(\rztbleed,\rztbleed) 
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

