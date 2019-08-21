unit createzone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Ingeo_TLB, InScripting_TLB;

type
  TfCreateZone = class(TForm)
    Label1: TLabel;
    eWidth: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    stlids:TStringList;
    selstyle:string;
    { Private declarations }
    procedure FillStyles;
    procedure MakeMultiZone;
  public
    app:IIngeoApplication;
    { Public declarations }
  end;

var
  fCreateZone: TfCreateZone;
  procedure StartcreateZone(app:IIngeoApplication);
implementation
uses Multizone, selstyle, addn;
{$R *.dfm}

  procedure StartcreateZone(app:IIngeoApplication);
  var f:TfCreateZone;
  begin
    f:=TfCreateZone.Create(nil);
    f.app:=app;
    f.ShowModal;
    f.Free;
  end;
procedure TfCreateZone.Button1Click(Sender: TObject);
begin
  MakeMultiZone;
end;

procedure TfCreateZone.Button2Click(Sender: TObject);
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrok then
  begin
    selstyle:=f.selstyle;
    Label3.Caption:=GetStyleName(selstyle);
   // objstyle:=selstyle;
  end;
end;


procedure TfCreateZone.FillStyles;
var stls:IIngeoStyles;
stl:IIngeoStyle;
  i: Integer;
begin
end;

procedure TfCreateZone.FormShow(Sender: TObject);
begin

  FillStyles;
end;

procedure TfCreateZone.MakeMultiZone;
var mt:TMultiZoneCreator;
  stlid: string;
  w:double;
begin
  w:=2;
  if not TryStrToFloat(eWidth.Text,w) then
  begin
    ShowMessage('Неверный ввод числа!');
    exit;
  end;
  if selstyle='' then
  begin
    ShowMessage('Не выбран стиль!');
    exit;
  end;
  stlid:=selstyle;
  mt:=TMultiZoneCreator.Create(app,stlid,w);
  mt.CreateZone;
end;

end.
