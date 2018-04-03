unit logging;

interface

uses
  classes, sysutils, windows;

type

  TLogLevel = (llDebug, llInfo, llWarning, llError );

  TLogfile = class
  private
    FLog: Text;
    FLogOpen: boolean;
    FCurrentLogLevel: TLogLevel;
  protected
    procedure OpenLog( _clearLog: boolean = true );
    procedure CloseLog;
    function GetLogLevelAsText( _logLevel: TLogLevel ): string;
  public
    constructor Create;
    destructor Destroy;

    procedure WriteToLog( _logLevel: TLogLevel; _text: string );

    property CurrentLogLeve: TLogLevel read FCurrentLogLevel write FCurrentLogLevel;

  end;

function Logfile: TLogfile;

implementation

var
  TheLogFileSingelton: TLogfile;

function Logfile: TLogfile;
begin
  if not assigned( TheLogFileSingelton ) then begin
    TheLogFileSingelton:= TLogfile.Create;
  end;
  result:= TheLogFileSingelton;
end;


{ TLogfile }

constructor TLogfile.Create;
begin
  FLogOpen:= false;
  FCurrentLogLevel:= llDebug;
end;

destructor TLogfile.Destroy;
begin
  CloseLog;
  Destroy();
end;

procedure TLogfile.OpenLog( _clearLog: boolean = true );
var
  fn: string;
begin
  try
    if not FLogOpen then begin
      fn:= ExtractFilePath( ParamStr(0) ) + 'liftoff.log';
      AssignFile( FLog, fn );
      if _clearLog then begin
        Rewrite( FLog );
      end else begin
        if FileExists( fn ) then Reset( FLog )
        else Rewrite( FLog );
      end;
      FLogOpen:= true;
    end;
  except
  end;
end;

procedure TLogfile.CloseLog;
begin
  try
    if FLogOpen then begin
      CloseFile( FLog );
      FLogOpen:= false;
    end;
  except
  end;
end;

procedure TLogfile.WriteToLog( _logLevel: TLogLevel; _text: string);
begin
  try
    if _logLevel >= CurrentLogLeve then begin
      OpenLog;
      WriteLn( Flog, DateTimeToStr( Now ) + '|' + GetLogLevelAsText( _logLevel ) + '|' + _text );
      Flush( FLog );
    end;
  except
  end;
end;

function TLogfile.GetLogLevelAsText(_logLevel: TLogLevel): string;
begin
  case _logLevel of
    llDebug: result:= 'debug';
    llInfo: result:= 'info';
    llWarning: result:= 'warning';
    llError: result:= 'error';
  end;
end;

initialization
  TheLogFileSingelton:= nil;
finalization
  FreeAndNil( TheLogFileSingelton );
end.
