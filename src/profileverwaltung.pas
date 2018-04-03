unit profileverwaltung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, ComCtrls, ImgList, profile, idTranslator;

type
  TfrmProfileMan = class(TForm)
    ImageList1: TImageList;
    lvProfile: TListView;
    dxBarManager1: TdxBarManager;
    miNew: TdxBarButton;
    miEdit: TdxBarButton;
    miDelete: TdxBarButton;
    miCopy: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    miDebug: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    translator: TidTranslator;
    procedure FormCreate(Sender: TObject);
    procedure miEditClick(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure lvProfileClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dxBarButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateProfileList;
    function EditProfil(AProfil: TProfil; IsNewProfil: boolean): boolean;
  end;

var
  frmProfileMan: TfrmProfileMan;

implementation

uses  ad_consts, id_string, id_tools, profildetails, maindata;

{$R *.dfm}

{ TfrmProfileMan }

procedure TfrmProfileMan.UpdateProfileList;
var
  SearchRec : TSearchRec;
  status : integer;
  p : integer;
  sExt : string;
  s : string;
begin

  Screen.Cursor:= crHourglass;
  try

    sExt := ProfilFileExt;
    Status := FindFirst(ProfilPath + '*' + sExt, faAnyFile, SearchRec);
    try
      lvProfile.Items.BeginUpdate;
      lvProfile.Clear;
      while status = 0 do begin
        with lvProfile.Items.Add do begin
          s := SearchRec.Name;
          p := Pos(UpperCase(sExt), UpperCase(s));
          if p > 0 then s := Copy(s, 1, p-1);
          Caption := s;
          ImageIndex := 0;
        end;

        status := FindNext(SearchRec);

      end;
    finally
      FindClose(SearchRec);
      lvProfile.Items.EndUpdate;
      lvProfileClick(Self);
    end;

  finally
    Screen.Cursor:= crDefault;
  end;

end;

procedure TfrmProfileMan.FormCreate(Sender: TObject);
begin
  if IsIDERunning then miDebug.Visible := ivAlways;
  UpdateProfileList;
end;

procedure TfrmProfileMan.miEditClick(Sender: TObject);
var
  Profil: TProfil;
begin
  if assigned(lvProfile.Selected) then begin
    Profil := TProfil.Create;
    try
      Profil.Dateiname := lvProfile.Selected.Caption;
      EditProfil(Profil, false);
    finally
      FreeAndNil(Profil);
    end;
  end;
end;

procedure TfrmProfileMan.miNewClick(Sender: TObject);
var
  NewProfilName: string;
  Profil : TProfil;
begin
  if InputQuery(translator.GetLit('NewAirfoilCaption'),
                translator.GetLit('NewAirfoilName'),
                NewProfilName) then
  begin
    Profil := TProfil.Create;
    try
      if Profil.New(NewProfilName) then
        if EditProfil(Profil, true) then UpdateProfileList;
    finally
      FreeAndNil(Profil);
    end;
  end;
end;

function TfrmProfileMan.EditProfil(AProfil: TProfil; IsNewProfil: boolean): boolean;
var
  frmProfilDetails: TfrmProfilDetails;
begin
  result := false;
  frmProfilDetails := TfrmProfilDetails.Create(self);
  try
    frmProfilDetails.Profil := AProfil;
    if frmProfilDetails.ShowModal = idOk then begin
      AProfil.Save;
      result := true;
    end;
  finally
    FreeAndNil(frmProfilDetails);
  end;
end;

procedure TfrmProfileMan.FormShow(Sender: TObject);
begin
  if  (not assigned(lvProfile.Selected))
  and (lvProfile.Items.Count > 0) then
    lvProfile.Selected := lvProfile.Items[0];

  translator.RefreshTranslation();
end;

procedure TfrmProfileMan.miDeleteClick(Sender: TObject);
var
  Profil: TProfil;
begin
  if  (assigned(lvProfile.Selected))
  and (Application.MessageBox(PChar(
                                Format(translator.GetLit('DeleteAirfoilQuestion'),
                                       [lvProfile.Selected.Caption]
                                )
                               ),
                               PChar(translator.GetLit('DeleteAirfoilCaption')),
                               mb_IconQuestion + mb_YesNo
                               ) = idYes) then
  begin
    Profil := TProfil.Create;
    try
      Profil.Dateiname := lvProfile.Selected.Caption;
      if Profil.Delete then UpdateProfileList;
    finally
      FreeAndNil(Profil);
      lvProfile.SetFocus;
    end;
  end;
end;

procedure TfrmProfileMan.lvProfileClick(Sender: TObject);
begin
  miCopy.Enabled := assigned(lvProfile.Selected);
  miEdit.Enabled := assigned(lvProfile.Selected);
  miDelete.Enabled := assigned(lvProfile.Selected);
end;

procedure TfrmProfileMan.miCopyClick(Sender: TObject);
var
  NewName: string;
  Profil: TProfil;
begin
  if  (assigned(lvProfile.Selected))
  and (InputQuery(translator.GetLit('CopyAirfoilCaption'), translator.GetLit('CopyAirfoilText'), NewName)) then
  begin
    Profil := TProfil.Create;
    try
      Profil.Dateiname := lvProfile.Selected.Caption;
      if Profil.SaveAs(NewName) then
        UpdateProfileList;
      lvProfile.Selected := lvProfile.FindCaption(0, NewName, false, true, true);
      if assigned(lvProfile.Selected) then
        lvProfile.Selected.MakeVisible(false);
    finally
      FreeAndNil(Profil);
    end;
  end;
end;

procedure TfrmProfileMan.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Capt : String;
begin
  if Key = vk_F5 then begin
    Capt := '';
    if assigned(lvProfile.Selected) then Capt := lvProfile.Selected.Caption;
    UpdateProfileList;
    lvProfile.Selected := lvProfile.FindCaption(0, Capt, false, true, true);
    if assigned(lvProfile.Selected) then
      lvProfile.Selected.MakeVisible(false);
  end else begin
    dmMain.CheckForSpecialKey(key, Shift, translator);
  end;
end;

procedure TfrmProfileMan.dxBarButton3Click(Sender: TObject);
var
  fn: string;
  f: textfile;
  profil: TProfil;
  SearchRec : TSearchRec;
  status : integer;
  sExt : string;
  fromRE,
  toRE : currency;
  p: integer;
  s: string;
begin
  Screen.Cursor := crHourGlass;
  try

    fn:= 'c:\temp\profile.csv';
    AssignFile(f, fn);
    Rewrite(f);
    try

      sExt := ProfilFileExt;
      Status := FindFirst(ProfilPath + '*' + sExt, faAnyFile, SearchRec);
      try
        while status = 0 do begin

          profil := TProfil.Create;
          try
            s := SearchRec.Name;
            p := Pos(UpperCase(sExt), UpperCase(s));
            if p > 0 then s := Copy(s, 1, p-1);

            try
              Profil.Dateiname := s;

              fromRE := 0;
              toRE := 0;

              if profil.Polaren.Count > 0 then begin
                fromRE:= profil.Polaren.Items[0].re;
                toRE:= profil.Polaren.Items[profil.Polaren.Count-1].re;
              end;

              WriteLn(f, Format(
                '"%s";%f;%f',
                [ ExtractFileName(profil.Dateiname),
                  fromRE,
                  toRE ]
                ));
            except
            end;

          finally
            status := FindNext(SearchRec);
            FreeAndNIl( profil );
          end;
        end;
      finally
        FindClose(SearchRec);
      end;

    finally
      CloseFile(f);
    end;

  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
