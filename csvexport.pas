unit csvexport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Ingeo_TLB,InScripting_TLB;

type
  TfCSVExport = class(TForm)
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);

  private

    { Private declarations }
    procedure ExportToCSV(fname:string);
  public
    { Public declarations }
  end;

var
  fCSVExport: TfCSVExport;

implementation
uses addn;
{$R *.dfm}

procedure TfCSVExport.Button1Click(Sender: TObject);
begin
 if gAddon2.Selection.Count=0 then
 begin
   ShowMessage('Не выделен объект!');
   exit;
 end;

 if SaveDialog1.Execute then
 begin
   ExportToCSV(SaveDialog1.FileName);
 end;
end;

procedure TfCSVExport.ExportToCSV(fname: string);
var mobjs:IIngeoMapObjects;
    obj:IIngeoMapObject;
    shp:IIngeoShape;
  si: Integer;
  text:TStringList;
  ci: Integer;
  cntp:IIngeoContourPart;
  vi: Integer;
  x,y,cv:double;
begin
  text:=TStringList.Create;
  obj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[0]);
  for si := 0 to obj.Shapes.Count - 1 do
  begin
    shp:=obj.Shapes.Item[si];
    if shp.DefineGeometry then
    begin
      for ci := 0 to shp.Contour  .Count - 1 do
      begin
        cntp:=shp.Contour.Item[ci];
        for vi := 0 to cntp.VertexCount - 1 do
        begin
          cntp.GetVertex(vi,x,y,cv);
          text.Add(Format('%.2f;%.2f',[x,y]));

        end;

      end;

    end;
  end;
  text.SaveToFile(fname);
  Close;
end;

end.
