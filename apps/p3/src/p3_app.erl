%%%-------------------------------------------------------------------
%% @doc p3 public API
%% @end
%%%-------------------------------------------------------------------

-module(p3_app).
% Boilerplate route setup.

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api", p3_api_handler, []}
        ]}
    ]),
    {ok, _Pid} = cowboy:start_clear(http,
            [{ip, {127, 0, 0, 1}}, {port, 8084}],
            #{ env => #{dispatch => Dispatch}}
    ),
    ratelimit:create_table(),
    p3_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ratelimit:delete_table(),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
