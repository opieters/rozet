\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{rozet}
    [2017/12/09 v0.1 Rozet document class for photo albums.]

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

\newlength\rztbleed
\setlength\rztbleed{3mm}

\newlength\rztmargin
\setlength\rztmargin{1cm}
\newlength\rztinnersep
\setlength\rztinnersep{0.3cm}

\AtBeginDocument{%
  \newlength\onePageHorImageWidth
  \setlength\onePageHorImageWidth{\paperwidth-2\rztmargin-2\rztbleed}
  \newlength\onePageHorImageHeight
  \setlength\onePageHorImageHeight{2\onePageHorImageWidth/3}

  \newlength\fourPageHorImageWidth
  \setlength\fourPageHorImageWidth{(\onePageHorImageWidth-\rztinnersep)/2}
  \newlength\fourPageHorImageHeight
  \setlength\fourPageHorImageHeight{(\onePageHorImageHeight-\rztinnersep)/2}

  \newlength\sixPageHorImageWidth
  \setlength\sixPageHorImageWidth{(\onePageHorImageWidth-2\rztinnersep)/3}
  \newlength\sixPageHorImageHeight
  \setlength\sixPageHorImageHeight{(\onePageHorImageHeight-\rztinnersep)/2}

  \newlength\twoPageSpreadImageWidth
  \setlength\twoPageSpreadImageWidth{\paperwidth-\rztmargin}
  \newlength\twoPageSpreadImageHeight
  \setlength\twoPageSpreadImageHeight{\paperheight-2\rztmargin}

  \ifx\ifKV@rzt@global@pagenumbers\iffalse
    \pagestyle{empty}
  \fi
}


\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\@IfNoValueOrEmptyTF}%
  {mmm}{\IfNoValueTF{#1}{#2}{
    \tl_if_empty:nTF {#1} {#2} {#3}%
   }
}
\ExplSyntaxOff

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
}

\NewDocumentCommand{\rztFirstAlbumPage}{m}{%
\begin{tikzpicture}[remember picture,overlay]
  #1
\end{tikzpicture}
}

\NewDocumentCommand{\rztAlbumPage}{mm}{%
\newpage
\begin{tikzpicture}[remember picture,overlay]
  #1
\end{tikzpicture}
\newpage
\begin{tikzpicture}[remember picture,overlay]
  #2
\end{tikzpicture}
}

\newlength\rztKey@width
\newlength\rztKey@height
\newlength\rzt@imgSize

\define@key{rzt@image}{note}{%
  \def\rztKey@note{#1}%
}% end of \define@key
\define@key{rzt@image}{xoffset}{%
  \def\rztKey@xoffset{#1}%
}% end of \define@key
\define@key{rzt@image}{yoffset}{%
  \def\rztKey@yoffset{#1}%
}% end of \define@key
\define@key{rzt@image}{width}{%
  \setlength\rztKey@width{#1}%
}% end of \define@key
\define@key{rzt@image}{height}{%
  \setlength\rztKey@height{#1}%
}% end of \define@key
\define@key{rzt@image}{zoom}{%
  \def\rztKey@zoom{#1}%
}% end of \define@key
\define@boolkey{rzt@image}{onlywidth}[true]{}%
\define@boolkey{rzt@image}{onlyheight}[true]{}%
% define size attributes for each image
\newlength\rzt@imgWidth%
\newlength\rzt@imgHeight%
\newlength\rzt@imgFrameWidth%
\newlength\rzt@imgFrameHeight%


% global options
\define@boolkey{rzt@global}{pagenumbers}[true]{}
\NewDocumentCommand{\rztalbumsetup}{m}{
  \setkeys{rzt@global}{%
    pagenumbers=false,
    #1
  }
}

% key-value with expl3 http://www.tug.org/TUGboat/tb31-1/tb97wright-l3keys.pdf

\NewDocumentCommand{\rzt@basicParseDefinitions}{mm}{%
  \@IfNoValueOrEmptyTF{#2}{%
    \def\rzt@nodestyle{rzt@noImage}%
    \def\rzt@indexLabel{\Huge #1}%
    \def\rzt@imageIncl{}%
    \setlength\rzt@imgWidth{0pt}%
    \setlength\rzt@imgHeight{0pt}%
  }{%
    % This part of the code defines the options that are passed to the 
    % includegraphics macro.
    %
    \ifKV@rzt@image@onlyheight% 
      \setlength{\rzt@imgSize}{\rztKey@height * \real{\rztKey@zoom}}%
    \else%
      \setlength{\rzt@imgSize}{\rztKey@width * \real{\rztKey@zoom}}%
    \fi%
    %
    \edef\rzt@imageOptions{%
      % check if width or height should be used
      % https://tex.stackexchange.com/questions/124252
      \ifKV@rzt@image@onlyheight%
        height=\rzt@imgSize,
      \else%
        width=\rzt@imgSize,
      \fi%
      %
    }%
    \def\rzt@nodestyle{rzt@image}%
    \def\rzt@indexLabel{\Huge\rztKey@note}%
    \settowidth\rzt@imgWidth{%
      \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}}%
    \settoheight\rzt@imgHeight{%
      \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}}%
    \def\rzt@imageIncl{%
      \node at ($(path picture bounding box.center)+%
        (0.5*\rzt@imgWidth*\rztKey@xoffset - 0.5*\rzt@imgFrameWidth*\rztKey@xoffset,%
         0.5*\rzt@imgHeight*\rztKey@yoffset - 0.5*\rzt@imgFrameHeight*\rztKey@yoffset)$){%
        \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}%
      };}%
  }%
}

\NewDocumentCommand{\rzt@basicNodeDefinition}{mm mm}{%
    \setlength\rzt@imgFrameWidth{#1}%
    \setlength\rzt@imgFrameHeight{#2}%
    \node[
      rzt@basic,
      \rzt@nodestyle,
      minimum width=#1,
      minimum height=#2,
      anchor=center,
      path picture={%
        \rzt@imageIncl
      },
      ] at ($(current page.center) %
            +(#3,#4)$)
      {\rzt@indexLabel};
      
}
