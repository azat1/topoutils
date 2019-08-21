unit vectorrotaterform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, vectorrotate;

type
  TfVectorRotater = class(TForm)
    Label1: TLabel;
    eAngle: TEdit;
    bRotate: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure bRotateClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    vectorrotater:TVectorRotater;
    { Public declarations }
  end;

var
  fVectorRotater: TfVectorRotater;

implementation

{$R *.dfm}

procedure TfVectorRotater.bRotateClick(Sender: TObject);
var ang:double;
begin
  if TryStrToFloat(eAngle.Text,ang) then
  begin
    vectorrotater.RotateSelected(ang);
  end
  else
  begin
    ShowMessage('Неверный ввод числа!');
  end;
end;

procedure TfVectorRotater.Button1Click(Sender: TObject);
begin
  vectorrotater.RotateSelected(90);
end;

procedure TfVectorRotater.Button2Click(Sender: TObject);
begin
  vectorrotater.RotateSelected(0);
end;

procedure TfVectorRotater.Button3Click(Sender: TObject);
begin
  vectorrotater.RotateSelected(180);
end;

procedure TfVectorRotater.Button4Click(Sender: TObject);
begin
  vectorrotater.RotateSelected(-90);

end;

end.
