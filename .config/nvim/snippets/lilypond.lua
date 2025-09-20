local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("score")([=[
\version "2.21.82"
\include "../../../template/bass-tab-score/0.2.0.ly"
% \include "swing.ly"

\pointAndClickOff

\header {
  title = ""
  composer = ""
}

silents = {
  \tempo 4 = 120
  \remark"Intro"
  \longRest 4

  \bar "|."
}

body = {
  % \tempo \markup {
  %   \rhythm { c4 } = 108
  %   \hspace #0.4
  %   (\rhythm { 16[ 16] } = \rhythm { \tuplet 3/2 { 8[ 16] } })
  % \tripletFeel 16 {

  \key c \major

  % }
}

chrds = \chordmode {
  % \longRest 4
  % a1:m
}

\score {
  <<
  \chords {
    \set chordChanges = ##t
    \set majorSevenSymbol = \markup { M7 }
    \chrds
  }
  \new Staff \with {
    \omit StringNumber
    midiInstrument = "electric bass (finger)"
  }{
    \clef "bass_8"
    \override MultiMeasureRest.expand-limit = #2
    << { \fixed c, {\body} } { \silents } >>
  }
  % \new TabStaff \with {
  %   stringTunings = #bass-five-string-tuning
  % } {
  %   \huge
  %   \set TabStaff.minimumFret = #3
  %   \set TabStaff.restrainOpenStrings = ##t
  %   \override MultiMeasureRest.expand-limit = #2
  %   \keepWithTag #'lower \body
  % }
  >>

  \layout {
    indent = #0
    \context {
      \Score
      proportionalNotationDuration = #(ly:make-moment 1/8)
    }
  }

  \midi {
    % \tempo 4 = 108
  }
}
]=])

return snips
