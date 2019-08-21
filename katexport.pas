unit katexport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ingeo_TLB;

type
  TfKatExport = class(TForm)
    cbZ: TComboBox;
    cbName: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    cbHZero: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure Loadfields;
    procedure ExportKat(fn:string);
    procedure GetObjCoords(obj:IIngeoMapObject;var x,y:real);
  public
    { Public declarations }
  end;

var
  fKatExport: TfKatExport;

implementation
uses addn;
{$R *.dfm}

procedure TfKatExport.FormShow(Sender: TObject);
begin
  LoadFields;
end;

procedure TfKatExport.Loadfields;
var st:IIngeoSemTables;
    i,t:integer;
    sst:IIngeoSemTable;
    fn:string;
begin
  cbZ.Items.Clear;
  st:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.SemTables;
  for i:=0 to st.Count-1 do
  begin
    sst:=st.Item[i];
    for t:=0 to sst.FieldInfos.Count-1 do
    begin
      fn:=sst.Name+'.'+sst.FieldInfos.Item[t].FieldName;
      cbZ.Items.Add(fn);
    end;
  end;
  cbName.Items:=cbZ.Items;
end;

procedure TfKatExport.Button1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    ExportKat(SaveDialog1.FileName);
  end;
end;

procedure TfKatExport.ExportKat(fn: string);
var katf:TStringList;
    i:integer;
    objid,tn1,tn2,fn1,fn2,pn,pz:string;
    obj:IIngeoMapObject;
    x,y,zz:real;
    oldsep:Char;
begin
  oldsep:=DecimalSeparator;
  DecimalSeparator:='.';
  if not cbHZero.Checked then
  begin
    tn1:=Copy(cbZ.Text,1,Pos('.',cbZ.Text)-1);
    fn1:=Copy(cbZ.Text,Pos('.',cbZ.Text)+1,300);
  end else
  begin
    zz:=0;
  end;

  tn2:=Copy(cbName.Text,1,Pos('.',cbName.Text)-1);
  fn2:=Copy(cbName.Text,Pos('.',cbName.Text)+1,300);
  katf:=TStringList.Create;
  for i:=0 to gAddon2.Selection.Count-1 do
  begin
    objid:=gAddon2.Selection.IDs[i];
    obj:=gAddon2.ActiveDb.MapObjects.GetObject(objid);
    if cbHZero.Checked  then zz:=0 else
    begin
      pz:=obj.SemData.GetValue(tn1,fn1,0);
      pz:=StringReplace(pz,',','.',[rfReplaceAll]);
      zz:=StrToFloat(pz);
    end;
    pn:=obj.SemData.GetValue(tn2,fn2,0);
    GetObjCoords(obj,x,y);
    katf.Add(Format('%-8.8s   75%12.3f%12.3f%12.3f 9999     000.00000',[pn,x,y,zz]));
  end;
  katf.SaveToFile(fn);
  katf.Free;
  DecimalSeparator:=oldsep;
end;

procedure TfKatExport.GetObjCoords(obj: IIngeoMapObject; var x, y: real);
var si,pi:integer;
    shp:IIngeoShape;
    x1,y1,x2,y2,cc:double;
begin
  for si:=0 to obj.Shapes.Count-1 do
  begin
    shp:=obj.Shapes.Item[si];
    for pi:=0 to shp.Contour.Count-1 do
    begin
      if (shp.Contour.Square=0)
         and (shp.Contour.Perimeter=0)
          then
         begin
           shp.Contour.GetBounds(x1,y1,x2,y2);
           x:=x1;
           y:=y1;
           exit;
         end;
    end;
  end;
  obj.Shapes.Item[0].Contour.Item[0].GetVertex(0,x1,y1,cc);
  x:=x1;
  y:=y1;
end;

end.
