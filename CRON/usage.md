```delphi
implementation

uses
  CRON;

begin
  if TCRON.Match('* * * * *', Now) then
    // do something if current time matches CRON pattern
end;
```
