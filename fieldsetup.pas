unit fieldsetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Menus, ComCtrls;

type
  TfFieldSetup = class(TForm)
    Button1: TButton;
    Button2: TButton;
    sgFields: TStringGrid;
    pm1: TPopupMenu;
    N1: TMenuItem;
    GroupBox1: TGroupBox;
    cbCoords: TCheckBox;
    cbAngles: TCheckBox;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Label3: TLabel;
    ePlanSizeX: TEdit;
    ePlanSizeY: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    N6: TMenuItem;
    N7: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N15: TMenuItem;
    N21: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTemplateFieldList;
    procedure LoadSemFieldList;
    procedure LoadSetupFile;
    procedure SaveSEtupFile;
  public
    { Public declarations }
  end;

var
  fFieldSetup: TfFieldSetup;

implementation
uses frm, comobj,Word_TLB,addn,strutils, Ingeo_TLB, M2Addon,M2AddonD,
  M2AddonImp;
{$R *.dfm}

procedure TfFieldSetup.FormShow(Sender: TObject);
begin
  sgFields.Cells[0,0]:='Поле шаблона';
  sgFields.Cells[1,0]:='Поле семантики';
  sgFields.ColWidths[1]:=300;
  LoadTemplateFieldList;
  LoadSemFieldList;
  LoadSetupFile;

end;

procedure TfFieldSetup.LoadSemFieldList;
var m:TMenuItem;
    sts:IIngeoSemTables;
    st:IIngeoSemTable;
    i,fi,fc,sc:integer;
    sellar:TM2ID;
begin
  sellar:=gAddon.MapProject.ActiveLayer;
//  cbb.Items.Clear;
  sts:=gAddon2.ActiveDB.LayerFromID(sellar).SemTables;
//  sts:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.SemTables;

  sc:=sts.Count;
  for i:=0 to sc-1 do
  begin
    st:=sts.Item[i];
    fc:=st.FieldInfos.Count;
    for fi:=0 to fc-1 do
    begin
      m:=TMenuItem.Create(self);
      m.Caption:='{'+st.Name+'.'+st.FieldInfos.Item[fi].FieldName+'}';
      m.OnClick:=N1Click;
      pm1.Items.Add(m);
//      cbb.Items.Add();
    end;
  end;
end;

procedure TfFieldSetup.LoadSetupFile;
var s:string;
    sf:TStringList;
    c,i:integer;
begin
  s:=Copy(s,1,Length(s)-4)+'.ini';
  sf:=TStringList.Create;
  try
    sf.LoadFromFile(s);
  except
    exit;
  end;
  for i:=1 to 199 do
  begin
//    c:=sf.IndexOfName(sgFields.Cells[0,i]);
//    if c<>-1 then
    begin
      sgFields.Cells[1,i]:=sf.Values[sgFields.Cells[0,i]];
    end;

  end;
  cbCoords.Checked:=sf.Values['GeoDataCoordsOut']='1';
  cbAngles.Checked:=sf.Values['GeoDataAnglesOut']='1';
  ePlanSizeX.Text:=sf.Values['PlanSizeX'];
  ePlanSizeY.Text:=sf.Values['PlanSizeY'];
end;

procedure TfFieldSetup.LoadTemplateFieldList;
var v:variant;
    templ:olevariant;
    i,c:integer;
begin
  v:=CreateOleObject('Word.Application');
  v.Documents.Add(templ);
  c:=v.ActiveDocument.Bookmarks.Count;
  for i:=1 to c do
  begin
    sgFields.Cells[0,i]:=v.ActiveDocument.Bookmarks.Item(i).Name;
  end;
  v.Quit;
end;

procedure TfFieldSetup.N1Click(Sender: TObject);
var n:TMenuItem;
begin
  n:=TMenuItem( Sender);
  sgFields.Cells[1,sgFields.Row]:=sgFields.Cells[1,sgFields.Row]+n.Caption;
  //dsgsdfg

end;

procedure TfFieldSetup.SaveSEtupFile;
var s:string;
    sf:TStringList;
    c,i:integer;
begin
  s:=Copy(s,1,Length(s)-4)+'.ini';
  sf:=TStringList.Create;

  for i:=1 to 199 do
  begin
    if Length(sgFields.Cells[0,i]+sgFields.Cells[1,i])>0 then
      sf.Add(sgFields.Cells[0,i]+ '='+sgFields.Cells[1,i]);

  end;
  sf.Add('PlanSizeX='+ePlanSizeX.Text);
  sf.Add('PlanSizeY='+ePlanSizeY.Text);
  sf.Add('GeoDataCoordsOut='+ifthen(cbCoords.Checked,'1'));
  sf.Add('GeoDataAnglesOut='+ifthen(cbAngles.Checked,'1'));

  sf.SaveToFile(s);
end;

procedure TfFieldSetup.Button1Click(Sender: TObject);
begin
  SaveSEtupFile;
end;

end.
