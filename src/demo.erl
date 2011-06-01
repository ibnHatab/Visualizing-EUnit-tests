%%% File    : demo.erl
%%% Author  : Thomas Arts <>
%%% Description : 
%%% Created : 14 May 2011 by Thomas Arts <>

-module(demo).

-export([frequency/0]).

frequency() ->
  % first run the tests to get the traces
  {Pos,Neg} = eunit_to_fsm:dynamic("../examples/frequency_tests.erl",
                                   [],fun({M,F,A}) when {M,F}=/={frequency,init} -> {M,F,A} end),
  % second create an automata
  Automata = bluefringe:qsm({Pos,Neg}),
  % third transform automata into QuickCheck template
  String = bluefringe_fsm:eqc_fsm(Automata,frequency),
  ok = file:write_file("frequency_eqc.erl",String),
  % Compile the QuickCheck code
  code:purge(frequency_eqc),
  compile:file("frequency_eqc.erl").