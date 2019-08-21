unit mfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, geom,
  StdCtrls, comobj;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    g:TGeometry;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses towrd;
{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var w:IUnknown;
    b:TInterfacedClass;
    v:TGUID;
begin
//  wapp:=GetActiveOleObject('Word.Application.8');

//  w.QueryInterface(v,wapp);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  g:=TGeometry.Create;
  g.count:=4;
  g.lx[0]:=0;
  g.lx[1]:=5;
  g.lx[2]:=7;
  g.lx[3]:=3;
  g.lx[4]:=0;

  g.ly[0]:=0;
  g.ly[1]:=-2;
  g.ly[2]:=4;
  g.ly[3]:=2;
  g.ly[4]:=0;
  Edit2.Text:=FloatToStr(g.GetIntersectX(2,1,-5,5));
  if g.IsIntersect(1, 0, 1.2,0.1,
                   0,5,-10,3   ) then Edit1.Text:='!!!!!!';
end;

end.
