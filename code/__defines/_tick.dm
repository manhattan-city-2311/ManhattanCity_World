#define TICK_LIMIT_TO_RUN 70
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT_DEFAULT 98
#define TICK_LIMIT_RUNNING (max(98 - world.map_cpu, TICK_LIMIT_MC))

#define TICK_USAGE world.tick_usage

#define TICK_CHECK ( TICK_USAGE > Master.current_ticklimit )
#define CHECK_TICK ( TICK_CHECK ? stoplag() : 0 )

#define TICK_CHECK_HIGH_PRIORITY ( TICK_USAGE > 98 )
#define CHECK_TICK_HIGH_PRIORITY ( TICK_CHECK_HIGH_PRIORITY ? stoplag() : 0 )

#define UNTIL(X) while(!(X)) stoplag()
