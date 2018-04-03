{********************************************************************}
{ TLOOKUP components : TLUEdit & TLUCombo                            }
{ for Delphi & C++Builder                                            }
{ version 2.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{ copyright © 1996-2003                                              }
{ Email : info@tmssoftware.com                                       }
{ Web : http://www.tmssoftware.com                                   }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the author and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

unit Lucombo;

{$I TMSDEFS.INC}

interface

uses
  Windows, Stdctrls, Classes, Dialogs, Messages, Controls, SysUtils,
  IniFiles, AdvCombo, Registry, Graphics;


type
//  TRegIniFile = class(TIniFile);

  TAutoCompleteEvent = procedure(Sender: TObject;const UsrStr:string; var AutoAdd:string;idx:integer) of object;
  TEnterAcceptEvent = procedure(Sender: TObject;const Str:string;idx:integer;var accept:boolean) of object;

  TAddToHistoryEvent = procedure(Sender: TObject; const Str:string) of object;

  TAutoHistoryDirection = (ahdFirst,ahdLast);

  TLUStorage = (stInifile,stRegistry);

  TLUPersist = class(TPersistent)
  private
    FEnable: Boolean;
    FStorage: TLUStorage;
    FKey: string;
    FSection: string;
    FCount: integer;
    FMaxCount: Boolean;
  published
    property Enable: Boolean read FEnable write FEnable;
    property Storage: TLUStorage read FStorage write FStorage;
    property Key: string read FKey write fKey;
    property Section: string read FSection write FSection;
    property Count: Integer read FCount write FCount;
    property MaxCount: Boolean read FMaxCount write FMaxCount;
  end;

  TLUCombo = class(TAdvComboBox)
  private
    workmode:boolean;
    ItemIdx:integer;
    ItemSel:integer;
    ItemChange:boolean;
    FLookupStr:string;
    FReturnIsTab:boolean;
    FAutoComplete:TAutoCompleteEvent;
    FEnterAccept:TEnterAcceptEvent;
    FOnAddToHistory:TAddToHistoryEvent;
    FAutoHistory:boolean;
    FAutoSynchronize:boolean;
    FFileLookup:boolean;
    FLUPersist:TLUPersist;
    FMatchCase:boolean;
    FFileLookupDir: string;
    FAutoHistoryLimit: Integer;
    FAutoHistoryDirection: TAutoHistoryDirection;
    FModified : Boolean;
    FModifiedColor : TColor;
    FDefaultColor : TColor;
    FOldValue : String;
    FShowModified: Boolean;
    procedure SetLUPersist(value:TLUPersist);
    procedure WMDestroy(var Msg:TMessage); message wm_Destroy;
    procedure SetModifiedColor(const Value: TColor);
    procedure SetModified(const Value: Boolean);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key:char); override;
    procedure DoExit; override;
  public
    procedure Change; override;
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure SavePersist;
    procedure LoadPersist;
    property FileLookupDir:string read fFileLookupDir write fFileLookupDir;
    property Modified:Boolean read fModified write SetModified;
  published
    property AutoComplete:TAutoCompleteEvent read FAutoComplete write FAutoComplete;
    property OnAddToHistory:TAddToHistoryEvent read FOnAddToHistory write FOnAddToHistory;
    property AutoHistory:boolean read FAutoHistory write FAutoHistory;
    property AutoHistoryLimit: Integer read FAutoHistoryLimit write FAutoHistoryLimit;
    property AutoHistoryDirection: TAutoHistoryDirection read  FAutoHistoryDirection write FAutoHistoryDirection;
    property AutoSynchronize:boolean read fAutoSynchronize write fAutoSynchronize;
    property ReturnIsTab:boolean read FReturnIsTab write FReturnIsTab;
    property Accept:TEnterAcceptEvent read FEnterAccept write FEnterAccept;
    property FileLookup:boolean read FFileLookup write FFileLookup;
    property Persist:TLUPersist read FLUPersist write SetLUPersist;
    property MatchCase:boolean read FMatchCase write FMatchCase;
    property ModifiedColor:TColor read fModifiedColor write SetModifiedColor;
    property ShowModified: Boolean read FShowModified write FShowModified;
  end;

  TLUEdit = class(TEdit)
  private
    workmode:boolean;
    FLookupItems:TStringList;
    FAutoComplete:TAutoCompleteEvent;
    FOnAddToHistory:TAddToHistoryEvent;
    FAutoHistory:boolean;
    FAutoSynchronize:boolean;
    FReturnIsTab:boolean;
    FEnterAccept:TEnterAcceptEvent;
    FFileLookup:boolean;
    FLUPersist:TLUPersist;
    FMatchCase:boolean;
    FFileLookupDir: string;
    FModified : Boolean;
    FModifiedColor : TColor;
    FDefaultColor : TColor;
    FOldValue : String;
    FAutoHistoryLimit: Integer;
    FAutoHistoryDirection: TAutoHistoryDirection;
    FShowModified: Boolean;
    procedure SetLookupItems(value:tstringlist);
    procedure SetLUPersist(value:TLUPersist);
    procedure WMDestroy(var Msg:TMessage); message wm_Destroy;
    procedure SetModifiedColor(const Value: TColor);
    procedure SetModified(const Value: Boolean);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key:char); override;
    procedure DoExit; override;
  public
    procedure Change; override;
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    procedure SavePersist;
    procedure LoadPersist;
    procedure Loaded; override;
    property FileLookupDir:string read fFileLookupDir write fFileLookupDir;
    property Modified:Boolean read fModified write SetModified;
  published
    property LookupItems:TStringList read fLookupItems write SetLookupItems;
    property AutoComplete:TAutoCompleteEvent read FAutoComplete write FAutoComplete;
    property OnAddToHistory:TAddToHistoryEvent read FOnAddToHistory write FOnAddToHistory;
    property Accept:TEnterAcceptEvent read FEnterAccept write FEnterAccept;
    property AutoHistory:boolean read FAutoHistory write FAutoHistory;
    property AutoHistoryLimit: Integer read FAutoHistoryLimit write FAutoHistoryLimit;
    property AutoHistoryDirection: TAutoHistoryDirection read  FAutoHistoryDirection write FAutoHistoryDirection;
    property AutoSynchronize:boolean read fAutoSynchronize write fAutoSynchronize;
    property ReturnIsTab:boolean read FReturnIsTab write FReturnIsTab;
    property FileLookup:boolean read fFileLookup write fFileLookup;
    property Persist:TLUPersist read fLUPersist write SetLUPersist;
    property MatchCase:boolean read FMatchCase write FMatchCase;
    property ModifiedColor:TColor read fModifiedColor write SetModifiedColor;
    property ShowModified: Boolean read FShowModified write FShowModified;        
  end;

implementation

function upstr(s:string;docase:boolean):string;
begin
  if docase then
    Result := s
  else
    Result := AnsiUpperCase(s);
end;

function ncpos(su,s:string):integer;
begin
  su := upstr(su,false);
  s := upstr(s,false);
  Result := pos(su,s);
end;

procedure TLUEdit.SetLookupItems(value:tstringlist);
begin
  if Assigned(value) then
    FLookupItems.Assign(value)
end;

procedure TLUEdit.DoExit;
var
  allowexit:boolean;
  i:integer;
  lu:TLUEdit;
begin
  AllowExit := True;
  
  if Assigned(FEnterAccept) then
  begin
    FEnterAccept(self,text,fLookupItems.IndexOf(Text),allowexit);
  end;
  if AllowExit and FAutoHistory and (Text <> '') then
  begin
    if (FLookupItems.Indexof(text)=-1) then
    begin
       if FAutoHistoryDirection = ahdLast then
       begin
         if (FAutoHistoryLimit > 0) and (FLookupItems.Count >= FAutoHistoryLimit) then
           FLookupItems.Delete(0);
         FLookupitems.Add(Text);
       end
       else
       begin
         if (FAutoHistoryLimit > 0) and (FLookupItems.Count >= FAutoHistoryLimit) then
           FLookupItems.Delete(FLookupItems.Count - 1);
         FLookupitems.Insert(0,Text);
       end;

       if Assigned(FOnAddToHistory) then
         FOnAddToHistory(self,text);

       if FAutoSynchronize then
       for I := 0 to Owner.ComponentCount - 1 do
         begin
           if (Owner.Components[I] is TLUEdit) and (Owner.Components[I]<>self) then
            begin
             lu:=Owner.Components[I] as TLUEdit;
             if (lu.AutoHistory) and (lu.Persist.key=self.Persist.Key) and (lu.AutoSynchronize) and (lu.Persist.Section=self.Persist.Section) then
                 lu.LookupItems.Assign(self.LookupItems);
             end;
         end;
     end;
   end;
 if allowexit then inherited DoExit else self.SetFocus;
end;

procedure TLUEdit.Change;
var
  c,c1:string;
  i:integer;
  UsrStr,AutoAdd:string;
  searchrec:tsearchrec;
  lud:string;

begin
  inherited Change;

  if csDesigning in ComponentState then
    Exit;

  if not WorkMode then
    Exit;

  if Text <> FOldValue then
    Modified := True
  else
    Modified := False;


  c1 := upstr(Text,FMatchCase);
  c := Copy(c1,1,selstart);

  if (FLookupItems.count > 0) and not FFileLookup then
    for i:=0 to fLookupItems.count-1 do
    begin
      if pos(c1,upstr(fLookupItems.Strings[i],fMatchCase))=1 then
      begin
        UsrStr := Copy(text,1,length(c));
        AutoAdd := Copy(fLookupItems.Strings[i],length(c)+1,255);

        if Assigned(FAutoComplete) then
          FAutoComplete(self,UsrStr,AutoAdd,i);

        Text := UsrStr+AutoAdd;

        SendMessage(Handle,EM_SETSEL,length(c),length(text));
        Exit;
      end;
    end;

 if  (length(self.text)>0) and (fFileLookup) then
  begin
   lud:=fFileLookupDir;
   if (length(lud)>0) then if lud[length(lud)]<>'\' then lud:=lud+'\';

   if findfirst(lud+self.Text+'*' ,faAnyfile,searchrec)=0 then
    begin
     c:=text;
     usrstr:='';
     while (pos(':',c)>0) do
       begin
        usrstr:=usrstr+copy(c,1,pos(':',c));
        delete(c,1,pos(':',c));
       end;
     while (pos('\',c)>0) do
       begin
        usrstr:=usrstr+copy(c,1,pos('\',c));
        delete(c,1,pos('\',c));
       end;

     if ((ncpos(c,searchrec.name)=1) or (c=''))
        and (ncpos('.',searchrec.name)<>1) then
      begin
       c:=text;
       text:=usrstr+searchrec.name;
       SendMessage(Handle,EM_SETSEL,length(c),length(text));
      end;
    end;
   findclose(searchrec);
  end;
end;

procedure TLUEdit.KeyPress(var key:char);
begin
 if (key=#13) and FReturnIsTab then key:=#0 else
 inherited Keypress(key);
end;

procedure TLUEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
 if not ((key=vk_return) and (FReturnIsTab)) then
 inherited KeyUp(key,shift);
end;

procedure TLUEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
 case Key of
 vk_back,vk_delete:workmode:=false;
 vk_return:begin
             if (fLookupItems.IndexOf(Text)<>-1) then
              begin
               text:=fLookupItems.Strings[fLookupItems.IndexOf(Text)];
               self.Change;
              end;
             if FReturnIsTab then
              begin
               postmessage(self.handle,wm_keydown,VK_TAB,0);
               key:=0;
              end;
             end;
 else workmode:=true;
 end;
 inherited KeyDown(key,shift);
end;

constructor TLUEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLookupItems := TStringList.Create;
  FLUPersist := TLUPersist.Create;
  workmode := True;
  FModifiedColor := clHighlight;
end;

destructor TLUEdit.Destroy;
begin
 fLookupItems.Free;
 fLUPersist.Free;
 inherited Destroy;
end;

procedure TLUEdit.SetLUPersist(value: TLUPersist);
begin
 fLUPersist.Assign(value);
end;

procedure TLUEdit.Loaded;
begin
 inherited Loaded;
 if not (csDesigning in ComponentState) then LoadPersist;
end;

procedure TLUEdit.WMDestroy(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then
    SavePersist;
  DefaultHandler(msg);
end;

procedure TLUEdit.SetModifiedColor(const Value: TColor);
begin
  FModifiedColor := Value;
  Invalidate;
end;

procedure TLUEdit.SetModified(const Value: Boolean);
begin
  if Value <> FModified then
  begin
    FModified := Value;
    if FModified then
    begin
      FDefaultColor := Font.Color;
      if FShowModified then
        Font.Color := FModifiedColor;
    end
    else
    begin
      if FShowModified then
        Font.Color := FDefaultColor;
      FOldValue := Text;
    end;
  end;
end;


procedure TLUEdit.LoadPersist;
var
 Inifile:tInifile;
 i:integer;
 s:string;
begin
 if self.fLUPersist.Enable then
  begin
    if self.fLUPersist.Storage=stInifile then
     Inifile:=TInifile.Create(self.fLUPersist.Key)
    else
     Inifile:=TInifile(TRegInifile.Create(self.fLUPersist.Key));

    self.LookupItems.Clear;
    i:=1;
    repeat
     s:=Inifile.ReadString(self.fLUPersist.Section,'Item'+inttostr(i),'');
     inc(i);
     if s<>'' then self.LookupItems.Add(s);
    until s='';

    Inifile.Free;
  end;
end;

procedure TLUEdit.SavePersist;
var
  Inifile: TInifile;
  i,j,k: Integer;
begin
  if FLUPersist.Enable then
  begin
    if FLUPersist.Storage = stInifile then
      Inifile := TInifile.Create(FLUPersist.Key)
    else
      Inifile := TInifile(TRegInifile.Create(FLUPersist.Key));

    j := 0;
    k := LookupItems.Count;
    if FLUPersist.MaxCount then
      k := FLUPersist.Count;

    if FLUPersist.MaxCount and (LookupItems.Count > FLUPersist.Count) then
      j := LookUpItems.Count - FLuPersist.Count;

    for i := 1 to k do
    begin
      if (i + j <= LookUpItems.Count) then
        Inifile.WriteString(FLUPersist.Section,'Item' + IntToStr(i),LookupItems.Strings[i + j - 1])
      else
        Inifile.WriteString(FLUPersist.Section,'Item' + IntToStr(i),'');
    end;

    Inifile.Free;
  end;
end;


procedure TLUCombo.KeyPress(var key:char);
begin
 inherited Keypress(key);
 if (key=#13) and FReturnIsTab then key:=#0;
end;

procedure TLUCombo.KeyUp(var Key: Word; Shift: TShiftState);
var
 i:integer;
begin
 if not ((key=vk_return) and (FReturnIsTab)) then
 inherited KeyUp(key,shift);

 if ItemChange and (Style=csDropDown) then
  begin
   itemindex:=ItemIdx;
   SendMessage(Handle,CB_SETEDITSEL,0,makelong(ItemSel,length(text)));
   ItemChange:=false;
  end;

 if (Style=csDropDownList) then
  begin
    for i:=0 to Items.count-1 do
     begin
       if pos(upstr(fLookupStr,fMatchCase),upstr(items[i],fMatchCase))=1 then
          begin
           ItemIndex:=i;
           break;
          end;
     end;
  end;



end;

procedure TLUCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
 case Key of
 vk_back,vk_delete:begin
                    workmode:=false;
                    FLookupStr:='';
                   end;
 vk_return:begin
             if FReturnIsTab then
               begin
                if droppeddown then
                 begin
                  ItemIdx:=itemindex;
                  droppeddown:=false;
                  itemindex:=itemidx;
                 end;
                postmessage(self.handle,wm_keydown,VK_TAB,0);
                key:=0;
               end
              else
               if (Items.IndexOf(Text)<>-1) then
                 begin
                  ItemIndex:=Items.IndexOf(Text);
                  self.Change;
                 end;

             end;

 vk_up,vk_down,vk_prior,vk_next:FLookupStr:='';
 else
   begin
    workmode:=true;
    if (ssShift in Shift) then FLookupStr:=FLookupStr+chr(key) else
      FLookupStr:=FLookupStr+lowercase(chr(key));
   end;
 end;

 inherited KeyDown(key,shift);
end;

procedure TLUCombo.DoExit;
var
 allowexit:boolean;
 i:integer;
 lu:TLUCombo;

begin
  allowexit:=true;
  if Assigned(FEnterAccept) then
  begin
    FEnterAccept(self,text,Items.IndexOf(Text),allowexit);
  end;

  if allowexit and fautohistory and (text<>'') then
  begin
    if items.indexof(text)=-1 then
      begin
       if FAutoHistoryDirection = ahdLast then
       begin
         if (FAutoHistoryLimit > 0) and (Items.Count >= FAutoHistoryLimit) then
           Items.Delete(0);
         Items.Add(Text);
       end
       else
       begin
         if (FAutoHistoryLimit > 0) and (Items.Count >= FAutoHistoryLimit) then
           Items.Delete(Items.Count - 1);
         Items.Insert(0,Text);
       end;
       if Assigned(FOnAddToHistory) then
         FOnAddToHistory(self,text);

       if FAutoSynchronize then
       for I := 0 to Owner.ComponentCount - 1 do
         begin
           if (Owner.Components[I] is TLUCombo) and (Owner.Components[I]<>self) then
            begin
             lu:=Owner.Components[I] as TLUCombo;
             if (lu.AutoHistory) and (lu.AutoSynchronize) and
                (lu.Persist.key=self.Persist.Key) and (lu.Persist.Section=self.Persist.Section) then
                 lu.Items.Assign(self.Items);
             end;
         end;
      end;
   end;

 if allowexit then inherited DoExit else self.SetFocus;
end;

procedure TLUCombo.Change;
var
 c,c1:string;
 i:integer;
 UsrStr,AutoAdd,Lud:string;
 searchrec:tsearchrec;

begin
  { if (text='') then workmode:=true; }
  ItemChange:=false;

  inherited Change;

  if csDesigning in ComponentState then Exit;

  if not workmode then
    Exit;

  workmode:=true;

  if Text <> fOldValue then
    Modified := true
  else
    Modified := false;

  c1 := upstr(Text,fMatchCase);
  c := Copy(c1,1,selstart);

  if c = '' then Exit;

  if (items.count>0) then
  for i:=0 to items.count-1 do
    begin
     if pos(c1,upstr(items[i],fMatchCase))=1 then
      begin
       UsrStr:=copy(Text,1,length(c));
       AutoAdd:=copy(Items[i],length(c)+1,255);
       if assigned(FAutoComplete) then
         begin
          FAutoComplete(self,UsrStr,AutoAdd,i);
         end;

       ItemIndex:=i;
       ItemIdx:=i;
       ItemSel:=length(c);
       ItemChange:=true;
       text:=UsrStr+AutoAdd;
       SendMessage(Handle,CB_SETEDITSEL,0,makelong(ItemSel,length(text)));
       exit;
      end;
   end;

 if (length(self.text)>0) and (fFileLookup) then
  begin
   lud:=fFileLookupDir;
   if (length(lud)>0) then if lud[length(lud)]<>'\' then lud:=lud+'\';

   if findfirst(lud+self.Text+'*' ,faAnyfile,searchrec)=0 then
    begin
     c:=text;
     usrstr:='';
     while (pos(':',c)>0) do
       begin
        usrstr:=usrstr+copy(c,1,pos(':',c));
        delete(c,1,pos(':',c));
       end;
     while (pos('\',c)>0) do
       begin
        usrstr:=usrstr+copy(c,1,pos('\',c));
        delete(c,1,pos('\',c));
       end;

     if ((ncpos(c,searchrec.name)=1) or (c=''))
        and (ncpos('.',searchrec.name)<>1) then
      begin
       c:=text;
       text:=usrstr+searchrec.name;
       SendMessage(Handle,CB_SETEDITSEL,0,makelong(length(c),length(text)));
      end;
    end;

   findclose(searchrec);
  end;


end;

constructor TLUCombo.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);
  workmode:=true;
  FLUPersist:=TLUPersist.Create;
  Flat:=false;
  ItemChange:=false;
  FLookupStr:='';
  FModifiedColor := clHighlight;
end;

procedure TLUCombo.SetLUPersist(value: TLUPersist);
begin
  FLUPersist.Assign(value);
end;

destructor TLUCombo.Destroy;
begin
 fLUPersist.Free;
 inherited Destroy;
end;

procedure TLUCombo.SavePersist;
var
 Inifile:TInifile;
 RegInifile:TRegInifile;
 i,j,k:integer;
begin
 if fLUPersist.Enable then
  begin
    if fLUPersist.Storage=stInifile then
     begin
     Inifile:=TInifile.Create(fLUPersist.Key);
     j:=0;
     k:=self.Items.Count;
     if fLUPersist.MaxCount then k:=fLUPersist.Count;

     if fLUPersist.MaxCount and (self.Items.Count>fLUPersist.Count) then
       j:=self.Items.Count-self.fLuPersist.Count;

     for i:=1 to k do
      begin
       if (i+j<=self.Items.Count) then
       begin
         Inifile.WriteString(fLUPersist.Section,'Item'+inttostr(i),self.Items.Strings[i+j-1])
       end
       else
         Inifile.WriteString(fLUPersist.Section,'Item'+inttostr(i),'');
      end;
     Inifile.Free;
     end
    else
     begin
     RegInifile:=TRegInifile.Create(fLUPersist.Key);
     j:=0;
     k:=self.Items.Count;
     if fLUPersist.MaxCount then k:=fLUPersist.Count;

     if fLUPersist.MaxCount and (self.Items.Count>fLUPersist.Count) then
       j:=self.Items.Count-self.fLuPersist.Count;

     for i:=1 to k do
      begin
        if (i+j<=self.Items.Count) then
         RegInifile.WriteString(fLUPersist.Section,'Item'+inttostr(i),self.Items.Strings[i+j-1])
        else
         RegInifile.WriteString(fLUPersist.Section,'Item'+inttostr(i),'');
      end;
     RegInifile.Free;
     end;
  end;
end;

procedure TLUCombo.LoadPersist;
var
 Inifile:TInifile;
 RegIniFile:TRegInifile;
 i:integer;
 s:string;
begin
 if self.fLUPersist.Enable then
  begin
    if self.fLUPersist.Storage=stInifile then
     begin
     Inifile:=TInifile.Create(self.fLUPersist.Key);
     self.Items.Clear;
     i:=1;
      repeat
       s:=Inifile.ReadString(self.fLUPersist.Section,'Item'+inttostr(i),'');
       inc(i);
       if s<>'' then self.Items.Add(s);
      until s='';
     Inifile.Free;
     end
    else
     begin
      RegInifile:=TRegInifile.Create(self.fLUPersist.Key);
      self.Items.Clear;
      i:=1;
      repeat
       s:=RegInifile.ReadString(self.fLUPersist.Section,'Item'+inttostr(i),'');
       inc(i);
       if s<>'' then self.Items.Add(s);
      until s='';
      RegInifile.Free;
     end;
  end;
end;

procedure TLUCombo.Loaded;
begin
 inherited Loaded;
 if not (csDesigning in ComponentState) then
   LoadPersist;
end;

procedure TLUCombo.WMDestroy(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then
    SavePersist;
  DefaultHandler(msg);
end;

procedure TLUCombo.SetModifiedColor(const Value: TColor);
begin
  FModifiedColor := Value;
  Invalidate;
end;

procedure TLUCombo.SetModified(const Value: Boolean);
begin
  if Value <> fModified then
  begin
    FModified := Value;

    if FModified then
    begin
      FDefaultColor := Font.Color;
      if ShowModified then
        Font.Color := FModifiedColor;
    end
    else
    begin
      if ShowModified then
        Font.Color := FDefaultColor;
      FOldValue := Text;
    end;
  end;
end;



end.
