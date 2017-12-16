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

\newlength\bleed
\setlength\bleed{3mm}

\newlength\margin
\setlength\margin{1cm}
\newlength\innersep
\setlength\innersep{0.3cm}

\AtBeginDocument{%
  \newlength\onePageHorImageWidth
  \setlength\onePageHorImageWidth{\paperwidth-2\margin-2\bleed}
  \newlength\onePageHorImageHeight
  \setlength\onePageHorImageHeight{2\onePageHorImageWidth/3}

  \newlength\fourPageHorImageWidth
  \setlength\fourPageHorImageWidth{(\onePageHorImageWidth-\innersep)/2}
  \newlength\fourPageHorImageHeight
  \setlength\fourPageHorImageHeight{(\onePageHorImageHeight-\innersep)/2}

  \newlength\sixPageHorImageWidth
  \setlength\sixPageHorImageWidth{(\onePageHorImageWidth-2\innersep)/3}
  \newlength\sixPageHorImageHeight
  \setlength\sixPageHorImageHeight{(\onePageHorImageHeight-\innersep)/2}

  \newlength\twoPageSpreadImageWidth
  \setlength\twoPageSpreadImageWidth{\paperwidth-\margin}
  \newlength\twoPageSpreadImageHeight
  \setlength\twoPageSpreadImageHeight{\paperheight-2\margin}
}


\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\@IfNoValueOrEmptyTF}%
  {mmm}{\IfNoValueTF{#1}{#2}{
    \tl_if_empty:nTF {#1} {#2} {#3}%
   }
}
\ExplSyntaxOff

\tikzset{%
rst@basic/.style={%
  rectangle,
  },
rst@noImage/.style={%
  rst@basic,
  fill opacity=0.5,
  text opacity=1,
  fill=gray,
  },
rst@image/.style={%
  rst@basic,
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

\define@key{rst@image}{xoffset}{%
  \def\rstKey@xoffset{#1}%
}% end of \define@key
\define@key{rst@image}{yoffset}{%
  \def\rstKey@yoffset{#1}%
}% end of \define@key
\define@key{rst@image}{width}{%
  \def\rstKey@width{#1}%
}% end of \define@key
\define@key{rst@image}{height}{%
  \def\rstKey@height{#1}%
}% end of \define@key
\define@key{rst@image}{zoom}{%
  \def\rstKey@zoom{#1}%
}% end of \define@key
\define@boolkey{rst@image}{onlywidth}[true]{}%
\define@boolkey{rst@image}{onlyheight}[true]{}%
% define size attributes for each image
\newlength\rst@imgWidth%
\newlength\rst@imgHeight%
\newlength\rst@imgFrameWidth%
\newlength\rst@imgFrameHeight%

% key-value with expl3 http://www.tug.org/TUGboat/tb31-1/tb97wright-l3keys.pdf

\NewDocumentCommand{\rzt@basicParseDefinitions}{mm}{%
  \@IfNoValueOrEmptyTF{#2}{%
    \def\rst@nodestyle{rst@noImage}%
    \def\rst@indexLabel{\Huge #1}%
    \def\rst@imageIncl{}%
    \setlength\rst@imgWidth{0pt}%
    \setlength\rst@imgHeight{0pt}%
  }{%
    % This part of the code defines the options that are passed to the 
    % includegraphics macro.
    \edef\rzt@imageOptions{%
      % check if width or height should be used
      % https://tex.stackexchange.com/questions/124252
      \ifKV@rst@image@onlyheight%
        height=\rstKey@height*\rstKey@zoom,
      \else%
        width=\rstKey@width*\rstKey@zoom,
      \fi%
      %
    }%
    \def\rst@nodestyle{rst@image}%
    \def\rst@indexLabel{}%
    \settowidth\rst@imgWidth{%
      \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}}%
    \settoheight\rst@imgHeight{%
      \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}}%
    \def\rst@imageIncl{%
      \node at ($(path picture bounding box.center)+%
        (0.5*\rst@imgWidth*\rstKey@xoffset - 0.5*\rst@imgFrameWidth*\rstKey@xoffset,%
         0.5*\rst@imgHeight*\rstKey@yoffset - 0.5*\rst@imgFrameHeight*\rstKey@yoffset)$){%
        \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}%
      };}%
  }%
}

\NewDocumentCommand{\rzt@basicNodeDefinition}{mm mm}{%
    \setlength\rst@imgFrameWidth{#1}%
    \setlength\rst@imgFrameHeight{#2}%
    \node[
      rst@basic,
      \rst@nodestyle,
      minimum width=#1,
      minimum height=#2,
      anchor=center,
      path picture={%
        \rst@imageIncl
      },
      ] at ($(current page.center) %
            +(#3,#4)$)
      {\rst@indexLabel};
      
}
