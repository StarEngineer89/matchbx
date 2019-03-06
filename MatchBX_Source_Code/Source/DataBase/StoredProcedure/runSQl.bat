for %%G in (*.sql) do sqlcmd /S {DB server} /d {DB name} -U {user} -P {paswword} -i"%%G"
pause