for %%G in (*.sql) do sqlcmd /S {DB link} /d {DB name} -U {DB username} -P {DB password} -i"%%G"
pause