-module(try_hackney).

-export([func/0]).

func() ->
    hackney:start(),

    %% ex1
    %% request(Method::term(), Hackney_url::url() | binary(), Headers::list(), Body::term(), Options0::list()) -> 
    %% {ok, integer(), list(), client_ref()} | {ok, client_ref()} | {error, term()}
    % {ok, _, _, Ref} = hackney:request(get, <<"https://friendpaste.com/_all_languages">>, [], <<>>),
    %{ok, Body} = hackney:body(Ref),
    %io:format("body: ~p~n", [Body]).
    % Status = hackney_manager:get_state(Ref),
    % io:format("Status: ~p~n", [Status]).

    Url = <<"https://friendpaste.com/_all_languages">>,
    Opts = [async],
    {ok, Ref} = hackney:get(Url, [], <<>>, Opts),
    loop(Ref).

loop(Ref) ->
    receive
        {hackney_response, Ref, {status, StatusInt, Reason}} ->
            io:format("got status: ~p with reason ~p~n", [StatusInt,
                                                          Reason]),
            loop(Ref);
        {hackney_response, Ref, {headers, Headers}} ->
            io:format("got headers: ~p~n", [Headers]),
            loop(Ref);
        {hackney_response, Ref, done} ->
            ok;
        {hackney_response, Ref, Bin} ->
            io:format("got chunk: ~p~n", [Bin]),
            loop(Ref);

        Else ->
            io:format("else ~p~n", [Else]),
            ok
    end.
