unit smtptransmitter;

interface

uses
  Classes,
  IdAssignedNumbers,
  IdEMailAddress,
  IdGlobal,
  IdHeaderList,
  IdMessage, IdMessageClient,
  IdSMTP;

type

  { This class can be used to send it to just one recipient (property RCPTAddress)
    in case e.g. the name resulution is done already before. }
  TidevSMTP = class(TidSMTP)
  private
    FRCPTAddress: string;
  public
    procedure Send( AMsg: TIdMessage ); reintroduce; overload;
    procedure Send( AFrom, ATo: string; AMessageContent: TStrings ); reintroduce; overload;
  published
    property RCPTAddress : string read FRCPTAddress write FRCPTAddress;
  end;

implementation

{ TidevSMTP }

procedure TidevSMTP.Send(AMsg: TIdMessage);

  function NeedToAuthenticate: Boolean;
  begin
    if FAuthenticationType <> atNone then begin
      Result := IsAuthProtocolAvailable(FAuthenticationType) and (FDidAuthenticate = False);
    end else begin
      Result := False;
    end;
  end;

begin
  SendCmd('RSET');
  if NeedToAuthenticate then begin
    Authenticate;
  end;
  SendCmd('MAIL FROM:<' + AMsg.From.Address + '>', 250);
  SendCmd('RCPT TO:<' + RCPTAddress + '>', [250, 251]);
  SendCmd('DATA', 354);
  //AMsg.ExtraHeaders.Values['X-Mailer'] := MailAgent;
  SendMsg(AMsg);
  SendCmd('.', 250);
end;

procedure TidevSMTP.Send(AFrom, ATo: string; AMessageContent: TStrings);

  function NeedToAuthenticate: Boolean;
  begin
    if FAuthenticationType <> atNone then begin
      Result := IsAuthProtocolAvailable(FAuthenticationType) and (FDidAuthenticate = False);
    end else begin
      Result := False;
    end;
  end;

begin
  SendCmd('RSET');
  if NeedToAuthenticate then begin
    Authenticate;
  end;
  SendCmd('MAIL FROM:<' + AFrom + '>', 250);
  SendCmd('RCPT TO:<' + ATo + '>', [250, 251]);
  SendCmd('DATA', 354);
  WriteStringS( AMessageContent );
  WriteLn('');
  SendCmd('.', 250);
end;

end.
