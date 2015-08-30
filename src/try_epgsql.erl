-module(try_epgsql).

-export([func/0]).

func() ->
    {ok, C} = epgsqla:start_link(),
    Ref = epgsqla:connect(C, "localhost", "postgres", "", [{database, "elixir_china"}]),
    receive 
        {C, Ref, connected} ->
            {ok, C};
        {C, Ref, Error = {error, _}} ->
            Error;
        {'EXIT', C, _Reason} ->
            {error, closed}
    end.

