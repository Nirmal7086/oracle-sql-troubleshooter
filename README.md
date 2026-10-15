# Oracle SQL Troubleshooter

**Experimental. Not ready for production use.**

This Bash script gathers diagnostics for an Oracle SQL_ID through SQL*Plus. The current code reads SQL text, execution plans, historical statistics, active sessions, bind values and SQL plan baselines.

## Known issues

- The wait-event query selects `EVENT`, `TOTAL_WAITS` and `TIME_WAITED_MICRO` from `V$SQL_MONITOR`. Those are not columns of that view in Oracle 19c. That section needs to be corrected.
- SQL_ID is inserted directly into SQL without validation.
- SQL*Plus does not use `WHENEVER SQLERROR EXIT`, so the final success message is not proof that every query worked.
- Recommendations use fixed counters, not workload baselines. They should not be treated as tuning decisions.

The current script uses `oraenv` and connects with `sqlplus / as sysdba`. That is broader access than a diagnostic tool should need. A least-privilege path and version-specific query tests are needed before a release.

The command format is:
```sh
bash sql_troubleshoot.sh <SQL_ID> [ORACLE_SID]
```

Review the code before trying it in an isolated lab. Historical performance queries may require separately licensed Oracle features. Output can expose SQL text, bind values, schema names and machine details. Don't share an unredacted report.

Fixing the input handling, query compatibility, error propagation and sensitive-output controls comes before calling this production-ready.
