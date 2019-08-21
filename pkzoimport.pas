unit pkzoimport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, M2Addon,M2AddonD,Ingeo_TLB;
const
   gkey='\Software\AzSoft\PKZO';
  gselstl:string='';
  gselfld:string='';

  gprecselstl:string='';
  gprecselfld:string='';

  gunprecborderstl:string='';
  gprecborderstl:string='';
  gcadnom:string='';
type
  TfPKZOImport = class(TForm)
    leFolder: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    sgPoints: TStringGrid;
    sgOPoints: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ImportData;
    procedure PreloadData;
    procedure LoadParams;
    procedure SaveParams;
    procedure CreateLot;
    procedure CreatePoints;
    procedure  GetPoint(pid:string;var x,y:real);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPKZOImport: TfPKZOImport;

implementation
uses filectrl, registry, addn;
{$R *.dfm}

procedure TfPKZOImport.Button1Click(Sender: TObject);
var dir:string;
begin
  if SelectDirectory('Выбрать папку','',dir) then
     leFolder.Text:=dir;
end;

procedure TfPKZOImport.Button2Click(Sender: TObject);
begin
  ImportData;
end;

procedure TfPKZOImport.ImportData;
begin
  PreloadData;
end;

procedure TfPKZOImport.PreloadData;
var sl,psl:TStringList;
    i,j:integer;
begin
  sl:=TStringList.Create;
  psl:=TStringList.Create;
  sl.LoadFromFile(leFolder.Text+'\Межевые точки.txt');
  psl.Delimiter:=';';
  sgPoints.RowCount:=sl.Count+1;
  for i:=0 to sl.Count-1 do
  begin
    psl.DelimitedText:=sl[i];
    for j:=0 to psl.Count-1 do
    begin
      sgPoints.Cells[j,i+1]:=psl[j];
    end;
  end;

  sl.LoadFromFile(leFolder.Text+'\opoint.txt');
  psl.Delimiter:=';';
  sgOPoints.RowCount:=sl.Count+1;
  for i:=0 to sl.Count-1 do
  begin
    psl.DelimitedText:=sl[i];
    for j:=0 to psl.Count-1 do
    begin
      sgOPoints.Cells[j,i+1]:=psl[j];
    end;
  end;
  CreateLot;
  CreatePoints;
end;

procedure TfPKZOImport.FormShow(Sender: TObject);
begin
  LoadParams;
end;

procedure TfPKZOImport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveParams;
end;

procedure TfPKZOImport.LoadParams;
var r:TRegistry;
    root:integer;
begin
  r:=TRegistry.Create;
  r.OpenKey(gkey,True);
  if r.ValueExists('FOLDER') then
     leFolder.Text:=r.ReadString('FOLDER');
  r.Free;
  root:=kprProject;
  gselstl:=gAddon.Preferences.GetString(root,kNoID,'pointstyle','');
  gselfld:=gAddon.Preferences.GetString(root,kNoID,'pointstylefield','');

  gprecselstl:=gAddon.Preferences.GetString(root,kNoID,'precpointstyle','');
  gprecselfld:=gAddon.Preferences.GetString(root,kNoID,'precpointstylefield','');

  gunprecborderstl:=gAddon.Preferences.GetString(root,kNoID,'unprecborderstyle','');
  gprecborderstl:=gAddon.Preferences.GetString(root,kNoID,'precborderstyle','');

  gcadnom:= gAddon.Preferences.GetString(root,kNoID,'cadnomfield','');
end;

procedure TfPKZOImport.SaveParams;
var r:TRegistry;
    root:integer;
begin
  r:=TRegistry.Create;
  r.OpenKey(gkey,True);
  r.WriteString('FOLDER',leFolder.Text);
  r.Free;
  root:=kprProject;
  gAddon.Preferences.SetString(root,kNoID,'pointstyle',gselstl);
  gAddon.Preferences.SetString(root,kNoID,'pointstylefield',gselfld);

  gAddon.Preferences.SetString(root,kNoID,'precpointstyle',gprecselstl);
  gAddon.Preferences.SetString(root,kNoID,'precpointstylefield',gprecselfld);

  gAddon.Preferences.SetString(root,kNoID,'precborderstyle',gprecborderstl);
  gAddon.Preferences.SetString(root,kNoID,'unprecborderstyle',gunprecborderstl);

  gAddon.Preferences.SetString(root,kNoID,'cadnomfield',gcadnom);
end;

procedure TfPKZOImport.CreateLot;
var mobjs:IIngeoMapObjects;
    newobj:IIngeoMapObject;
    newshp:IIngeoShape;
    cp:IIngeoContourPart;
    lar,pid:string;
    i:integer;
    x,y,cnv:real;
begin
  lar:=gAddon2.ActiveDb.StyleFromID(gprecborderstl).Layer.ID;
  mobjs:= gAddon2.ActiveDb.MapObjects;
  newobj:=mobjs.AddObject(lar);
  newshp:= newobj.Shapes.Insert(0,gprecborderstl);
//  cp:=newshp.Contour.Insert(0);
  cnv:=0;
  for i:=1 to sgOPoints.RowCount-1 do
  begin
    if sgOPoints.Cells[3,i]='1' then
    begin
      cp:=newshp.Contour.Insert(newshp.Contour.Count);
      cp.Closed:=True;
    end;
    pid:=sgOPoints.Cells[1,i];
    GetPoint(pid,x,y);
    cp.InsertVertex(cp.VertexCount,x,y,cnv);
  end;
  mobjs.UpdateChanges;
//  newshp.Contour.Insert()
end;

procedure TfPKZOImport.CreatePoints;
begin

end;

procedure TfPKZOImport.GetPoint(pid: string; var x, y: real);
var i:integer;
begin
  DecimalSeparator:='.';
  for i:=1 to sgPoints.RowCount-1 do
  begin
    if sgPoints.Cells[0,i]=pid then
    begin
      x:=StrToFloat(sgPoints.Cells[5,i]);
      y:=StrToFloat(sgPoints.Cells[4,i]);
      DecimalSeparator:=',';
      exit;
    end;
  end;
  DecimalSeparator:=',';
end;

end.
