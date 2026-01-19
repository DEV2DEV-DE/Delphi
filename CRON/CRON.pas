unit CRON;

// Die Klasse TCRON bietet eine KLassenfunktion Match(TDateTime)
// um zu prüfen, ob ein bestimmtes Datum/Uhrzeit zum in Pattern
// übergebenes CRON-Muster passt
//
// ┌───────────── Minute (0-59)
// │ ┌───────────── Stunde (0-23)
// │ │ ┌───────────── Tag des Monats (1-31)
// │ │ │ ┌───────────── Monat (1-12)
// │ │ │ │ ┌───────────── Wochentag (0-6 Sonntag bis Samstag)
// │ │ │ │ │
// * * * * *

interface

type
  TCRONPattern = record
    minutes: string;
    hours: string;
    days: string;
    months: string;
    weekdays: string;
    constructor Create(const APattern: string);
  end;

  TCRON = class(TObject)
    private
      FPattern: TCRONPattern;
      FMinutes: array[0..59] of Boolean;
      FHours: array[0..23] of Boolean;
      FDays: array[1..31] of Boolean;
      FMonths: array[1..12] of Boolean;
      FWeekdays: array[0..6] of Boolean;
      procedure InitializeArray(var AArray: array of Boolean; AValue: Boolean); overload;
      procedure InitializeArray(var AArray: array of Boolean; const APattern: string); overload;
      procedure InitializeArray(var AArray: array of Boolean; AIndex: Integer); overload;
      procedure InitializeArrayRecurring(var AArray: array of Boolean; const APattern: string);
      procedure InitializeArrayList(var AArray: array of Boolean; const APattern: string);
      procedure InitializeArrayArea(var AArray: array of Boolean; const APattern: string);
      function MatchesDateTime(ATime: TDateTime): Boolean;
    public
      constructor Create(const APattern: string); reintroduce;
      class function Match(const APattern: string; ATime: TDateTime): Boolean;
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils;

{ TCRONPattern }

constructor TCRONPattern.Create(const APattern: string);
var
  LArray: TArray<string>;
begin
  LArray := APattern.Split([' ']);
  if Length(LArray) = 5 then
  begin
    minutes := LArray[0];
    hours := LArray[1];
    days := LArray[2];
    months := LArray[3];
    weekdays := LArray[4];
  end else
    raise Exception.Create('Invalid number of CRON parts');

end;

{ TCRON }

constructor TCRON.Create(const APattern: string);
begin
  inherited Create;
  FPattern := TCRONPattern.Create(APattern);
  InitializeArray(FMinutes, FPattern.minutes);
  InitializeArray(FHours, FPattern.hours);
  InitializeArray(FDays, FPattern.days);
  InitializeArray(FMonths, FPattern.months);
  InitializeArray(FWeekdays, FPattern.weekdays);
end;

// Alle Elemente auf einen bestimmten Wert setzen
procedure TCRON.InitializeArray(var AArray: array of Boolean; AValue: Boolean);
var
  i: Integer;
begin
  for i := Low(AArray) to High(AArray) do
    AArray[i] := AValue;
end;

// Muster auf Array anwenden
procedure TCRON.InitializeArray(var AArray: array of Boolean; const APattern: string);
begin
  if APattern.Equals('*') then
    InitializeArray(AArray, True)
  else if APattern.Contains('/') then
    InitializeArrayRecurring(AArray, APattern)
  else if APattern.Contains(',') then
    InitializeArrayList(AArray, APattern)
  else if APattern.Contains('-') then
    InitializeArrayArea(AArray, APattern)
  else
    InitializeArray(AArray, APattern.ToInteger);
end;

// Einzelnes Element des Array auf "true" setzen
// Muster 30 14 * * *
procedure TCRON.InitializeArray(var AArray: array of Boolean; AIndex: Integer);
begin
  AArray[AIndex] := True;
end;

// Elemente X bis Y eines Array (Bereich) auf "true" setzen
// Muster 30 8-10 * * *
procedure TCRON.InitializeArrayArea(var AArray: array of Boolean; const APattern: string);
var
  tmp: TArray<string>;
  i: Integer;
begin
  tmp := APattern.Split(['-']);
  for i := Low(AArray) to High(AArray) do
    if (i >= tmp[0].ToInteger) and (i <= tmp[1].ToInteger) then
      AArray[i] := True;
end;

// Bestimmte Elemente einer Liste 2,7,15 (Liste) auf "true" setzen
// Muster 30 2,4,6,8 * * *
procedure TCRON.InitializeArrayList(var AArray: array of Boolean; const APattern: string);
var
  tmp: TArray<string>;
  i: Integer;
begin
  tmp := APattern.Split([',']);
  for i := Low(tmp) to High(tmp) do
    InitializeArray(AArray, tmp[i]);
end;

// Elemente "alle X" (Schrittweite) setzen
// Muster */5 * * * * (alle 5 Minuten)
procedure TCRON.InitializeArrayRecurring(var AArray: array of Boolean; const APattern: string);
var
  tmp: TArray<string>;
  i, ARest: Integer;
begin
  tmp := APattern.Split(['/']);
  for i := Low(AArray) to High(AArray) do
  begin
    ARest := i mod tmp[1].ToInteger;
    if (i = 0) or (ARest = 0) then
      AArray[i] := True;
  end;
end;

// prüft, ob ein gegebenes Muster zum Zeitstempel passt
class function TCRON.Match(const APattern: string; ATime: TDateTime): Boolean;
var
  Instance: TCRON;
begin
  Instance := TCRON.Create(APattern);
  try
    Result := Instance.MatchesDateTime(ATime);
  finally
    Instance.Free;
  end;
end;

function TCRON.MatchesDateTime(ATime: TDateTime): Boolean;
begin
  Result := FMinutes[MinuteOf(ATime)] and
            FHours[HourOf(ATime)] and
            FDays[DayOf(ATime)] and
            FMonths[MonthOf(ATime)] and
            FWeekdays[DayOfWeek(ATime) - 1];
end;

end.
