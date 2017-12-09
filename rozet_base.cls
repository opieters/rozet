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

\NewDocumentCommand{\rstFirstAlbumPage}{m}{%
\begin{tikzpicture}[remember picture,overlay]
  #1
\end{tikzpicture}
}

\NewDocumentCommand{\rstAlbumPage}{mm}{%
\newpage
\begin{tikzpicture}[remember picture,overlay]
  #1
\end{tikzpicture}
\newpage
\begin{tikzpicture}[remember picture,overlay]
  #2
\end{tikzpicture}
}


\@tempcnta=0
\loop
  \advance\@tempcnta 1
  \expandafter\newif\csname ifrst@onlyheight\@Alph\@tempcnta\endcsname%
  \expandafter\newif\csname ifrst@onlywidth\@Alph\@tempcnta\endcsname%
  \csname rst@onlyheight\@Alph\@tempcnta false\endcsname
  \csname rst@onlywidth\@Alph\@tempcnta true\endcsname
\ifnum\@tempcnta<6
\repeat

% https://tex.stackexchange.com/questions/206791
\@tempcnta=0
\loop
  \advance\@tempcnta 1
  \begingroup\edef\x{\endgroup
    \noexpand\define@key{rst@image\@Alph\@tempcnta}{xoffset}{%
      \noexpand\@namedef{rstKey@xoffset\@Alph\@tempcnta}{####1}%
    }% end of \define@key
    \noexpand\define@key{rst@image\@Alph\@tempcnta}{yoffset}{%
      \noexpand\@namedef{rstKey@yoffset\@Alph\@tempcnta}{####1}%
    }% end of \define@key
    \noexpand\define@key{rst@image\@Alph\@tempcnta}{width}{%
      \noexpand\@namedef{rstKey@width\@Alph\@tempcnta}{####1}%
    }% end of \define@key
    \noexpand\define@key{rst@image\@Alph\@tempcnta}{height}{%
      \noexpand\@namedef{rstKey@height\@Alph\@tempcnta}{####1}%
    }% end of \define@key
    \noexpand\define@boolkey{rst@image\@Alph\@tempcnta}{onlywidth}[true]{}%
    \noexpand\define@boolkey{rst@image\@Alph\@tempcnta}{onlyheight}[true]{}%
    % define size attributes for each image
    \noexpand\newlength\csname rst@imgWidth\@Alph\@tempcnta\endcsname%
    \noexpand\newlength\csname rst@imgHeight\@Alph\@tempcnta\endcsname%
    \noexpand\newlength\csname rst@imgFrameWidth\@Alph\@tempcnta\endcsname%
    \noexpand\newlength\csname rst@imgFrameHeight\@Alph\@tempcnta\endcsname%
  }% end of \edef
  \x % execute \x
\ifnum\@tempcnta<6
\repeat

% key-value with expl3 http://www.tug.org/TUGboat/tb31-1/tb97wright-l3keys.pdf

\NewDocumentCommand{\rst@basicParseDefinitions}{mm}{%
  \@IfNoValueOrEmptyTF{#2}{%
    \expandafter\def\csname rst@nodestyle#1\endcsname{rst@noImage}%
    \expandafter\def\csname rst@indexLabel#1\endcsname{\Huge #1}%
    \expandafter\def\csname rst@imageIncl#1\endcsname{}%
    \expandafter\setlength\csname rst@imgWidth#1\endcsname{0pt}%
    \expandafter\setlength\csname rst@imgHeight#1\endcsname{0pt}%
  }{%
    \expandafter\def\csname rst@nodestyle#1\endcsname{rst@image}%
    \expandafter\def\csname rst@indexLabel#1\endcsname{}%
    \expandafter\settowidth\csname rst@imgWidth#1\endcsname{%
      \includegraphics{#2}}%
    \expandafter\settoheight\csname rst@imgHeight#1\endcsname{%
      \includegraphics{#2}}%
    % This part of the code defines the options that are passed to the 
    % includegraphics macro.
    \edef\rst@imageOptions{%
      % check if width or height should be used
      % https://tex.stackexchange.com/questions/124252
      \expandafter%
      \ifx\csname ifKV@rst@image#1@onlyheight\endcsname%
        \iftrue%
        height=\csname rstKey@height#1\endcsname,
      \else%
        width=\csname rstKey@width#1\endcsname,
      \fi%
      %
    }%
    \expandafter\def\csname rst@imageIncl#1\endcsname{%
      \node at ($(path picture bounding box.center)+%
        (0.5*\csname rst@imgWidth#1\endcsname%
         *\csname rstKey@xoffset#1\endcsname%
         - 0.5*\csname rst@imgFrameWidth#1\endcsname%
         *\csname rstKey@xoffset#1\endcsname,%
         0.5*\csname rst@imgHeight#1\endcsname%
         *\csname rstKey@yoffset#1\endcsname%
         -0.5*\csname rst@imgFrameHeight#1\endcsname%
         *\csname rstKey@yoffset#1\endcsname)$){%
        \expandafter\includegraphics\expandafter[\rst@imageOptions]{#2}%
      };}%
  }%
}

\NewDocumentCommand{\rst@basicNodeDefinition}{m mm mm}{%
    \expandafter\setlength\csname rst@imgFrameWidth#1\endcsname{#2}%
    \expandafter\setlength\csname rst@imgFrameHeight#1\endcsname{#3}%
    \node[
      rst@basic,
      \csname rst@nodestyle#1\endcsname,
      minimum width=#2,
      minimum height=#3,
      anchor=center,
      path picture={%
        \csname rst@imageIncl#1\endcsname
      },
      ] at ($(current page.center) %
            +(#4,#5)$)
      {\csname rst@indexLabel#1\endcsname};
      
}
