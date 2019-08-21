unit rasterchange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TfRasterChange = class(TForm)
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    eX: TEdit;
    eY: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    idlist:TStringList;
    procedure MakeChange;
    procedure LoadMaps;
  public
    { Public declarations }
  end;

var
  fRasterChange: TfRasterChange;

implementation
uses addn, Ingeo_TLB;
{$R *.dfm}

procedure TfRasterChange.Button1Click(Sender: TObject);
begin
  MakeChange;
end;

procedure TfRasterChange.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfRasterChange.FormShow(Sender: TObject);
begin
  LoadMaps;
end;

procedure TfRasterChange.LoadMaps;
var
  i: Integer;
  map:IIngeoMap;
begin
  idlist:=TStringList.Create;
  for i := 0 to gAddon2.ActiveProjectView.MapViews.Count - 1 do
  begin
    map:=gAddon2.ActiveProjectView.MapViews.Item[i].Map;
    if map.MapType=inmtRaster then
    begin
      CheckListBox1.Items.Add(map.Name);
      idlist.Add(map.ID);
    end;
  end;

end;

procedure TfRasterChange.MakeChange;
var dx,dy:double;
  I: Integer;
  map:IIngeoRasterMap;
begin
  if not TryStrToFloat(eX.Text,dx) then
  begin
    ShowMessage('Неверный ввод X');
    exit;
  end;
  if not TryStrToFloat(eY.Text,dy) then
  begin
    ShowMessage('Неверный ввод Y');
    exit;
  end;

  for I := 0 to CheckListBox1.Count - 1 do
  begin
    if CheckListBox1.Checked[i] then
    begin
      map:=gAddon2.ActiveDb.MapFromID(idlist[i]) as IIngeoRasterMap;
      map.OffsetX:=map.OffsetX+dx;
      map.OffsetY:=map.OffsetY+dy;
      map.Update;
    end;
  end;
  ShowMessage('Выполнено!');
  Close;
end;

end.
