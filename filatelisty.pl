:- encoding(utf8).
:- use_module(library(lists)).

% Задача про филателистов
%
% Серый Волк, Ниф-Ниф, Наф-Наф и Нуф-Нуф собирают марки: флора, спорт,
% космос и фауна (фауну собирает Волк). Все сидят за столом в доме Волка.
%   Волк сидит слева от Наф-Нафа.
%   Ниф-Ниф сидит справа от того, кто собирает марки про космос.
%   Нуф-Нуф сидит напротив Наф-Нафа и не интересуется спортом.
% Можно ли определить, какие марки собирает каждый?
%
% Места за столом 1, 2, 3, 4 по часовой стрелке, если смотреть сверху.
% Все сидят лицом к столу, поэтому слева от того, кто сидит на месте N,
% будет место N+1, а справа место N-1 (после 4 снова идет 1).

sleva(A, B) :- A =:= B mod 4 + 1.          % A сидит слева от B
sprava(A, B) :- sleva(B, A).               % A сидит справа от B
naprotiv(A, B) :- A =:= (B + 1) mod 4 + 1.  % A сидит напротив B

% Если всех пересадить по кругу, условия не поменяются, поэтому
% каждое решение нашлось бы 4 раза. Чтобы этого не было, Волк
% (он хозяин) всегда сидит на месте 1.

reshenie(Geroi) :-
    Geroi = [g(volk, 1, fauna), g(nif, MNif, TNif),
             g(naf, MNaf, TNaf), g(nuf, MNuf, TNuf)],
    permutation([2, 3, 4], [MNif, MNaf, MNuf]),
    permutation([flora, sport, kosmos], [TNif, TNaf, TNuf]),
    sleva(1, MNaf),
    member(g(_, MKosmos, kosmos), Geroi),
    sprava(MNif, MKosmos),
    naprotiv(MNuf, MNaf),
    TNuf \= sport.

imya(volk, 'Серый Волк').
imya(nif, 'Ниф-Ниф').
imya(naf, 'Наф-Наф').
imya(nuf, 'Нуф-Нуф').

tema(flora, 'флора').
tema(sport, 'спорт').
tema(kosmos, 'космос').
tema(fauna, 'фауна').

pechat([]).
pechat([g(G, M, T) | Ost]) :-
    imya(G, Imya),
    tema(T, Tema),
    format("~w (место ~w): ~w~n", [Imya, M, Tema]),
    pechat(Ost).

% запуск: ?- otvet.
otvet :-
    findall(G, reshenie(G), Vse),
    length(Vse, N),
    format("Найдено решений: ~w~n", [N]),
    forall(member(R, Vse), (nl, pechat(R))),
    nl,
    (   N =:= 1
    ->  writeln('Ответ: да, тематику марок каждого можно определить однозначно.')
    ;   N =:= 0
    ->  writeln('Решений нет, условия противоречат друг другу.')
    ;   writeln('Ответ: нет, однозначно определить нельзя.')
    ).
