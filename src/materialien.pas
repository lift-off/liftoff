unit materialien;

interface
uses
  classes, sysutils;

type

  THolmart = record
    Bezeichnung: string;
    Gurtmaterial: string;
    Stegmaterial: string;
    Kernmaterial: string;
    SigmaZul: currency;     // N/mm2
    TauZul: currency;       // N/mm2
    TauKern: currency;      // N/mm2
    BerechnungsMethode: integer; // 1 = GFK, 2 = Kiefer
  end;

var

  Holmarten: array[ 0..1 ]  of THolmart = (

    (Bezeichnung: 'CFK-Holm';
     Gurtmaterial: 'CFK Roving 24000 FIL (bei Verwendung anderer FIL-Anzahl muss linear umgerechnet werden)';
     Stegmaterial: 'GFK Gewebe';
     Kernmaterial: 'Rohacell 51';
     SigmaZul: 800;
     TauZul: 80;
     TauKern: 0.8;
     BerechnungsMethode: 1
    ),

    (Bezeichnung: 'Kiefer-Holm';
     Gurtmaterial: 'Kiefer, feinjährig';
     Stegmaterial: 'Flugzeugsperrholz';
     Kernmaterial: 'kein Kernmaterial';
     SigmaZul: 70;
     TauZul: 20;
     TauKern: 0.1;
     BerechnungsMethode: 2
    )
  );

procedure LoadSparTexts();
  
implementation

uses
  maindata;

procedure LoadSparTexts();
begin
  Holmarten[0].Bezeichnung := dmMain.Translator.GetLit('MaterialCFKDescription');
  Holmarten[0].Gurtmaterial := dmMain.Translator.GetLit('MaterialCFKSparCap');
  Holmarten[0].Stegmaterial := dmMain.Translator.GetLit('MaterialCFKSparWeb');
  Holmarten[0].Kernmaterial := dmMain.Translator.GetLit('MaterialCFKCore');

  Holmarten[1].Bezeichnung := dmMain.Translator.GetLit('MaterialWoodDescription');
  Holmarten[1].Gurtmaterial := dmMain.Translator.GetLit('MaterialWoodSparCap');
  Holmarten[1].Stegmaterial := dmMain.Translator.GetLit('MaterialWoodSparWeb');
  Holmarten[1].Kernmaterial := dmMain.Translator.GetLit('MaterialWoodCore');
end;

end.
