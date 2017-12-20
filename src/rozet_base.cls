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

\setlength\rztmargin{1cm}
\setlength\rztbleed{3mm}
\setlength\rztspine{8mm}
\setlength\rztgutter{10mm}
\setlength\rztfront{200mm}
\setlength\rztback{200mm}
\setlength\rztinnersep{0.3cm}
\setlength\rztcoverwidth{2\rztbleed+\rztback+2\rztgutter+\rztspine+\rztfront}
\setlength\rztcoverheight{200mm}

\newlength\onePageHorImageWidth
\newlength\onePageHorImageHeight
\newlength\fourPageHorImageWidth
\newlength\fourPageHorImageHeight
\newlength\sixPageHorImageWidth
\newlength\sixPageHorImageHeight
\newlength\twoPageSpreadImageWidth  \newlength\twoPageSpreadImageHeight

\newlength\rzt@coverxoffset
\setlength\rzt@coverxoffset{0pt}
\newlength\rzt@coveryoffset
\setlength\rzt@coveryoffset{0pt}

\NewDocumentCommand{\rzt@setImageDimensions}{}{
  \setlength\onePageHorImageWidth{\rztpaperwidth-2\rztmargin-2\rztbleed}
  \setlength\onePageHorImageHeight{2\onePageHorImageWidth/3}


  \setlength\fourPageHorImageWidth{(\onePageHorImageWidth-\rztinnersep)/2}
  \setlength\fourPageHorImageHeight{(\onePageHorImageHeight-\rztinnersep)/2}

  \setlength\sixPageHorImageWidth{(\onePageHorImageWidth-2\rztinnersep)/3}
  \setlength\sixPageHorImageHeight{(\onePageHorImageHeight-\rztinnersep)/2}

  \setlength\twoPageSpreadImageWidth{\paperwidth-\rztmargin}
  \setlength\twoPageSpreadImageHeight{\paperheight-2\rztmargin}
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

\AtEndDocument{%
\immediate\closeout\rzt@imagedatafile
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
}
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

\define@key{rzt@image}{note}{\def\rztKey@note{#1}}
\define@key{rzt@image}{xoffset}{\def\rztKey@xoffset{#1}}
\define@key{rzt@image}{yoffset}{\def\rztKey@yoffset{#1}}
\define@key{rzt@image}{width}{\setlength\rztKey@width{#1}}
\define@key{rzt@image}{height}{\setlength\rztKey@height{#1}}
\define@key{rzt@image}{zoom}{\def\rztKey@zoom{#1}}
\define@key{rzt@image}{showframe}{\def\rztKey@showframe{#1}}
\define@boolkey{rzt@image}{onlywidth}[true]{}
\define@boolkey{rzt@image}{onlyheight}[true]{}
\define@boolkey{rzt@image}{text}[true]{}

% define size attributes for each image
\newlength\rzt@imgWidth%
\newlength\rzt@imgHeight%
\newlength\rzt@imgFrameWidth%
\newlength\rzt@imgFrameHeight%


% global options
\define@boolkey{rzt@global}{pagenumbers}[true]{}
\define@boolkey{rzt@global}{includegutter}[true]{}
\define@boolkey{rzt@global}{showcoverframe}[true]{}
\define@boolkey{rzt@global}{cover}[true]{}
\define@key{rzt@global}{spine}{\setlength\rztspine{#1}}
\define@key{rzt@global}{bleed}{\setlength\rztbleed{#1}}
\define@key{rzt@global}{gutter}{\setlength\rztgutter{#1}}
\define@key{rzt@global}{front}{\setlength\rztfront{#1}}
\define@key{rzt@global}{back}{\setlength\rztback{#1}}
\define@key{rzt@global}{height}{\setlength\rztheight{#1}}
\define@key{rzt@global}{width}{\setlength\rztwidth{#1}}

% cover options
\define@key{rzt@cover}{title}{\def\rzt@covertitle{#1}}
\define@key{rzt@cover}{spinetitle}{\def\rzt@coverspinetitle{#1}}

\NewDocumentCommand{\rztalbumsetup}{m}{
  \setkeys{rzt@global}{%
    pagenumbers={false},%
    spine={14mm},%
    gutter={10mm},%
    bleed={19mm},%
    front={206.5mm},%
    back={206.5mm},%
    includegutter={false},%
    showcoverframe={false},%
    height={210mm},%
    width={297mm},%
    cover={false},%
    #1
  }
  \ifKV@rzt@global@cover
  \setlength\rztcoverwidth{2\rztbleed+\rztback+2\rztgutter+\rztspine+\rztfront}
  \setlength\rztcoverheight{2\rztbleed+\rztheight}
  \setlength\rztpaperwidth{2\rztbleed+\rztback+2\rztgutter+\rztspine+\rztfront}
  \setlength\rztpaperheight{2\rztbleed+\rztheight}
  \else
  \setlength\rztpaperwidth{\rztwidth+2\rztbleed}
  \setlength\rztpaperheight{\rztheight+2\rztbleed}
  \fi
  \expandafter\message{Set coverwidth to: \the\rztcoverwidth}
}

% key-value with expl3 http://www.tug.org/TUGboat/tb31-1/tb97wright-l3keys.pdf

% from: \url{https://tex.stackexchange.com/questions/8260}
\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\thelength}{ O{mm} m }
 {
  \fp_to_decimal:n { round ( (#2)/(1#1), 5 ) } #1
 }
\ExplSyntaxOff

\NewDocumentCommand{\rzt@reportImage}{m}{%
  \immediate\write\rzt@imagedatafile{\space\space -}
  \immediate\write\rzt@imagedatafile{\space\space\space\space "filename": "#1":}
  \immediate\write\rzt@imagedatafile{\space\space\space\space "width": "\thelength{\rzt@imgWidth}"}
  \immediate\write\rzt@imagedatafile{\space\space\space\space "height": "\thelength{\rzt@imgHeight}"}
}

\newsavebox{\rzt@box}

\newcommand{\IfNoText}[3]{%
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

\def\rzt@boxText{}
\def\rzt@boxTextOptions{}
\NewDocumentCommand{\rztTextBox}{O{} m}{% 
  \gdef\rzt@boxText{#2}%
  \gdef\rzt@boxTextOptions{#1}%
}
\NewDocumentCommand{\rzt@resetTextBox}{}{
  \gdef\rzt@boxText{}%
  \gdef\rzt@boxTextOptions{}%
}

\NewDocumentCommand{\rzt@basicParseDefinitions}{mm}{%
  \@IfNoValueOrEmptyTF{#2}{%
    \def\rzt@nodestyle{rzt@noImage}%
    \def\rzt@indexLabel{\Huge #1}%
    \def\rzt@imageIncl{}%
    \setlength\rzt@imgWidth{0pt}%
    \setlength\rzt@imgHeight{0pt}%
  }{%
    \ifKV@rzt@image@onlyheight% 
      \setlength{\rzt@imgSize}{\rztKey@height * \real{\rztKey@zoom}}%
    \else%
      \setlength{\rzt@imgSize}{\rztKey@width * \real{\rztKey@zoom}}%
    \fi%
    \ifKV@rzt@image@text%
      \sbox{\rzt@box}{#2}
      \def\rzt@nodestyle{rzt@text}%
      \def\rzt@indexLabel{\IfNoText{\rzt@boxText}{#2}{\rzt@boxText}}%
      \def\rzt@imageIncl{}%
      \setlength\rzt@imgWidth{0pt}%
      \setlength\rzt@imgHeight{0pt}%
    \else%
      % This part of the code defines the options that are passed to the 
      % includegraphics macro.
      %
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
      \rzt@reportImage{#2}
      \def\rzt@imageIncl{%
        \node at ($(path picture bounding box.center)+%
          (0.5*\rzt@imgWidth*\rztKey@xoffset - 0.5*\rzt@imgFrameWidth*\rztKey@xoffset,%
          0.5*\rzt@imgHeight*\rztKey@yoffset - 0.5*\rzt@imgFrameHeight*\rztKey@yoffset)$){%
          \expandafter\includegraphics\expandafter[\rzt@imageOptions]{#2}%
        };}%
    \fi%
  }%
}


\NewDocumentCommand{\rzt@basicNodeDefinition}{mm mm}{%
    \setlength\rzt@imgFrameWidth{#1}%
    \setlength\rzt@imgFrameHeight{#2}%
    \node[
      rzt@basic,
      minimum width=#1,
      minimum height=#2,
      \rzt@nodestyle,
      anchor=center,
      path picture={%
        \rzt@imageIncl
      },
      ] at ($(current page.center) %
            +(#3,#4)
            +(\rzt@coverxoffset,\rzt@coveryoffset)$)
      {\rzt@indexLabel};
      \rzt@resetTextBox
}

\NewDocumentCommand{\rztCover}{O{} mmm}{%
  \setkeys{rzt@cover}{%
    title={\@title},
    spinetitle={\@title},
    #1
  }
\begin{tikzpicture}[remember picture,overlay,every node/.style={inner sep={0pt}, outer sep={0pt}}]
  \ifKV@rzt@global@includegutter
    \setlength\rztpaperwidth{\rztfront+\rztgutter+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \else
    \setlength\rztpaperwidth{\rztfront+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \fi
  \rzt@setImageDimensions
  
  \ifKV@rzt@global@includegutter
    \setlength\rzt@coverxoffset{-0.5\rztspine-0.5\rztgutter-0.5\rztfront-0.5\rztbleed}
  \else
    \setlength\rzt@coverxoffset{-0.5\rztspine-\rztgutter-0.5\rztfront-0.5\rztbleed}
  \fi
  #2
  
  \ifKV@rzt@global@includegutter
    \setlength\rztpaperwidth{\rztspine}
    \setlength\rztpaperheight{\rztcoverheight}
  \else
    \setlength\rztpaperwidth{2\rztgutter+\rztspine}
    \setlength\rztpaperheight{\rztcoverheight}
  \fi
  \setlength\rzt@coverxoffset{0pt}
  #3
  
  \ifKV@rzt@global@includegutter
    \setlength\rztpaperwidth{\rztfront+\rztgutter+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \else
    \setlength\rztpaperwidth{\rztfront+\rztbleed}
    \setlength\rztpaperheight{\rztcoverheight}
  \fi
  \rzt@setImageDimensions
  
  \ifKV@rzt@global@includegutter
    \setlength\rzt@coverxoffset{0.5\rztspine+0.5\rztgutter+0.5\rztfront+0.5\rztbleed}
  \else
    \setlength\rzt@coverxoffset{0.5\rztspine+\rztgutter+0.5\rztfront+0.5\rztbleed}
  \fi
  #4
  
  \ifKV@rzt@global@showcoverframe
  \draw[fill=green!50] (current page.north) -- ++(\rztspine/2,0) -- ++(0,-\rztcoverheight) -- ++(-\rztspine,0) -- ++(0,\rztcoverheight) -- cycle;
  \draw[fill=red!50] (current page.north)++(\rztspine/2,0) -- ++(\rztgutter,0) -- ++(0,-\rztcoverheight) -- ++(-\rztgutter,0) -- ++(0,\rztcoverheight) -- cycle;
  \draw[fill=blue!50] (current page.north)++(-\rztspine/2,0) -- ++(-\rztgutter,0) -- ++(0,-\rztcoverheight) -- ++(\rztgutter,0) -- ++(0,\rztcoverheight) -- cycle;
  \draw[fill=yellow!50] (current page.north west) -- ++(\rztbleed,0) -- ++(0,-\rztcoverheight) -- ++(-\rztbleed,0) -- ++(0,\rztcoverheight) -- cycle;
  \draw[fill=yellow!50] (current page.north east) -- ++(-\rztbleed,0) -- ++(0,-\rztcoverheight) -- ++(\rztbleed,0) -- ++(0,\rztcoverheight) -- cycle;
  \draw[fill=yellow!50] (current page.north west) -- ++(\paperwidth,0) -- ++(0,-\rztbleed) -- ++(-\paperwidth,0) -- ++(0,\rztbleed) -- cycle;
  \draw[fill=yellow!50] (current page.south west) -- ++(\paperwidth,0) -- ++(0,\rztbleed) -- ++(-\paperwidth,0) -- ++(0,-\rztbleed) -- cycle;
  \fi
  
  \node[rzt@coverspinetitle,white] at (current page.center) {\fontsize{0.75\rztspine}{0.85\rztspine}\selectfont \rzt@coverspinetitle };
  \node[rzt@covertitle,white,align=right,anchor=south east] at ($(current page.south east)+(-2\rztbleed,2\rztbleed)$) {\rzt@covertitle };
\end{tikzpicture}
}

\NewDocumentCommand{\rztBackground}{m}{
  \node[
    minimum width=\rztpaperwidth,
    minimum height=\rztpaperheight,
    #1 %
    ] at (current page.center) {};
}

