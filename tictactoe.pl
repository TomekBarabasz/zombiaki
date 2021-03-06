:-dynamic cell/3.
:-dynamic does/2.
:-dynamic true/1.

distinct(X,Y) :- X\=Y.

% initial state
init(true(control(xplayer))).
init(true(cell(1,1,b))).
init(true(cell(1,2,b))).
init(true(cell(1,3,b))).
init(true(cell(2,1,b))).
init(true(cell(2,2,b))).
init(true(cell(2,3,b))).
init(true(cell(3,1,b))).
init(true(cell(3,2,b))).
init(true(cell(3,3,b))).

%legal moves
legal(P,mark(X,Y))  :-  true(cell(X,Y,b)),true(control(P)).
legal(xplayer,noop) :-  true(cell(_,_,b)),true(control(oplayer)).
legal(oplayer,noop) :-  true(cell(_,_,b)),true(control(xplayer)).

%state update
next(true(cell(M,N,x))) :-  does(xplayer,mark(M,N)).
next(true(cell(M,N,o))) :-  does(oplayer,mark(M,N)).
next(true(cell(M,N,W))) :-  true(cell(M,N,W)),distinct(W,b).
next(true(cell(M,N,b))) :-
    true(cell(M,N,b)),
    does(_,mark(J,K)),
    (distinct(M,J);distinct(N,K)).
next(true(control(xplayer))) :-  true(control(oplayer)).
next(true(control(oplayer))) :-  true(control(xplayer)).

terminal :- line(x);line(o).
terminal :- \+ open.

line(W) :- row(M,W).
line(W) :- column(N,W).
line(W) :- diagonal(W).
open :- true(cell(M,N,b)).

row(M,W) :-
  true(cell(M,1,W)),
  true(cell(M,2,W)),
  true(cell(M,3,W)).

column(N,W) :-
  true(cell(1,N,W)),
  true(cell(2,N,W)),
  true(cell(3,N,W)).

diagonal(W) :-
  true(cell(1,1,W)),
  true(cell(2,2,W)),
  true(cell(3,3,W)).

diagonal(W) :-
  true(cell(1,3,W)),
  true(cell(2,2,W)),
  true(cell(3,1,W)).

goal(xplayer,50)  :- line(x),line(o),open.
goal(xplayer,100) :- line(x).
goal(xplayer,0)   :- line(o).

goal(oplayer,50)  :- line(x),line(o),open.
goal(oplayer,100) :- line(o).
goal(oplayer,0)   :- line(x).

%start_game(S) :-
%  findall(X,init(X),List),
%  convlist([R,H]>>assertz(R,H), List, S).

start_game :- foreach(init(X),assertz(X)).
next_state :-
  \+ terminal,
  findall(X,next(X),NewState),
  foreach(true(Y),retract(true(Y))),
  foreach(does(P,M),retract(does(P,M))),
  foreach(member(Z,NewState),assertz(Z)).






