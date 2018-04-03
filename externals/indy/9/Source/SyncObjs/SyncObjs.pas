{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  19827: SyncObjs.pas 
{
{   Rev 1.0    2003.06.12 12:51:56 PM  czhower
{ Initial checkin
}
unit SyncObjs;

interface

uses
  Windows;

type
  TCriticalSection = class(TObject)
  protected
    FRTLCriticalSection: TRTLCriticalSection;
  public
    procedure Acquire;
    constructor Create;
    destructor Destroy; override;
    procedure Enter;
    procedure Leave;
    procedure Release;
  end;

implementation

{ TCriticalSection }

procedure TCriticalSection.Acquire;
begin
  Enter;
end;

constructor TCriticalSection.Create;
begin
  inherited;
  InitializeCriticalSection(FRTLCriticalSection);
end;

destructor TCriticalSection.Destroy;
begin
  DeleteCriticalSection(FRTLCriticalSection);
  inherited;
end;

procedure TCriticalSection.Enter;
begin
  EnterCriticalSection(FRTLCriticalSection);
end;

procedure TCriticalSection.Leave;
begin
  LeaveCriticalSection(FRTLCriticalSection);
end;

procedure TCriticalSection.Release;
begin
  Leave;
end;

end.
