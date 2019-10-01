





:- dynamic(kb/1).

makeKB(File):- open(File,read,Str),    % MAKING KNOWLEDGE BASE FROM FILE
               readK(Str,K),
               reformat(K,KB),
               asserta(kb(KB)),
               close(Str).

mkList((H,T),[H|F]) :- !, mkList(T,F).      % MAKING LIST
 						             mkList(H,[H]).

ascendSort([H|T], F) :- sort(H, [], T, F).                   % SORTS LIST TO FIND SMALLEST NODE
                        sort(H, L, [], [H|L]).

sort(U, L, [H|T], F) :- lessthan(U, H), !,                   % RECURSIVE SORT
                        sort(U, [H|L], T, F);
                        sort(H, [U|L], T, F).


reformat([],[]).                                             % REFORMATTING FILE AND MAKING LIST
reformat([end_of_file],[]) :- !.
reformat([:-(H,BR)|L],[[H|BL]|R]) :- !,
                                    mkList(BR,BL),
                                    reformat(L,R).
reformat([X|L],[[X]|R]) :- reformat(L,R).


addtofrontier(C, F, NF) :- append(C, F, TF),
                           ascendSort(TF, NF).    % ADDS TO NEW FRONTIER USING A TEMP FRONTIER

astar([[N, P, C]|_], [N,P], C, _) :- goal(N).                  % IMPLEMENT A*

astar([[N, PT, CT]|R], P, C, KB) :- findall([X,[N|PT],Sum],
                                    (arc(N, X, Y, KB), Sum is Y+CT), C),
							        addtofrontier(C, R, TF),
							        astar(TF, P, C, KB).




%Taken from question pdf
readK(Stream,[]):- at_end_of_stream(Stream),!.

readK(Stream,[X|L]):- read(Stream,X),
                      readK(Stream,L).

initKB(File) :- retractall(kb(_)),
		        makeKB(File).


arc([H|T],Node,Cost,KB) :- member([H|B],KB),
    					   append(B,T,Node),
						   length(B,L),
    					   Cost is L+1.


heuristic(Node,H) :- length(Node,H).

goal([]).



astar(Node,Path,Cost) :- kb(KB),
    					 astar(Node,Path,Cost,KB).



lessthan([Node1,_,Cost1|_],[Node2,_,Cost2|_]) :- heuristic(Node1,Hvalue1),
												 heuristic(Node2,Hvalue2),
												 F1 is Cost1+Hvalue1,
												 F2 is Cost2+Hvalue2,
												 F1 =< F2.
